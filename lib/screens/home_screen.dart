import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../services/location_service.dart';
import '../models/dipendente.dart';
import '../models/timbratura.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import 'storico_screen.dart';
import 'dart:async';
import 'dart:io';
import '../services/export_service.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class HomeScreen extends StatefulWidget {
  final Dipendente dipendente;

  const HomeScreen({super.key, required this.dipendente});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  bool _isSyncing = false;
  int _pendingCount = 0;
  bool _isRestoringFromServer = false;
  String _restoreStatus = 'Sincronizzazione iniziale non avviata';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _loadPendingCount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_sincronizzaDalServer());
    });
  }

  void _updateTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _esportaTimbrature() async {
    // Carica tutte le timbrature locali del dipendente
    final tutte = await DatabaseService.getTutteTimbratureLocali();
    final mieTimbrature = tutte
        .where((t) => t.dipendenteId == widget.dipendente.id)
        .toList();

    if (mieTimbrature.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nessuna timbratura da esportare'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      final dateFormat = DateFormat('yyyyMMdd');
      final nomeFile =
          'Timbrature_${widget.dipendente.cognome}_${dateFormat.format(DateTime.now())}';

      final filePath = await ExportService.esportaTimbrature(
        mieTimbrature,
        nomeFile,
      );

      if (filePath != null && mounted) {
        // Condividi il file
        assert([XFile(filePath)].isNotEmpty);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            subject: 'Timbrature ${widget.dipendente.nomeCompleto}',
            text: 'Le mie timbrature',
            sharePositionOrigin: null,
            fileNameOverrides: null,
            downloadFallbackEnabled: Share.downloadFallbackEnabled,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore durante l\'export'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loadPendingCount() async {
    final pending = await DatabaseService.getTimbratureNonSincronizzate();
    if (mounted) {
      setState(() {
        _pendingCount = pending.length;
      });
    }
  }

  Future<void> _timbra(String tipo) async {
    Position? posizione;
    String? indirizzo;

    try {
      posizione = await LocationService.getCurrentLocation(
        timeout: const Duration(milliseconds: 800),
      );
      if (posizione != null) {
        indirizzo = await LocationService.getAddressFromCoords(
          posizione.latitude,
          posizione.longitude,
        );
      }
    } catch (e) {
      print('Errore nel recupero rapido della posizione: $e');
    }

    final timbratura = Timbratura(
      dipendenteId: widget.dipendente.id,
      tipo: tipo,
      dataOra: DateTime.now(),
      sincronizzato: false,
      latitudine: posizione?.latitude,
      longitudine: posizione?.longitude,
      indirizzo: indirizzo,
    );

    final insertedId = await DatabaseService.inserisciTimbratura(timbratura);
    final timbraturaSalvata = timbratura.copyWith(id: insertedId);

    if (mounted) {
      String messaggio = '${timbraturaSalvata.tipoLabel} registrata';
      if (posizione != null && indirizzo != null) {
        messaggio += '\nPosizione: $indirizzo';
      } else {
        messaggio += '\nPosizione non disponibile';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messaggio),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    await _completaRegistrazione(timbraturaSalvata);
    unawaited(_sincronizza());
  }

  Future<void> _completaRegistrazione(Timbratura timbratura) async {
    try {
      final posizione = await LocationService.getCurrentLocation(
        timeout: const Duration(seconds: 2),
      );
      final verificaFerie = await ApiService.verificaFerie(
        widget.dipendente.id,
      );

      if (posizione != null && timbratura.id != null) {
        final indirizzo = await LocationService.getAddressFromCoords(
          posizione.latitude,
          posizione.longitude,
        );

        await DatabaseService.aggiornaCoordinateTimbratura(
          timbratura.id!,
          latitudine: posizione.latitude,
          longitudine: posizione.longitude,
          indirizzo: indirizzo,
        );
      }

      if (verificaFerie['in_ferie'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Non puoi timbrare: sei in ${verificaFerie['ferie']['tipo']}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }
    } catch (e) {
      print('Errore nel completamento della timbratura: $e');
    }
  }

  Future<void> _sincronizzaDalServer() async {
    if (!mounted) return;

    setState(() {
      _isRestoringFromServer = true;
      _restoreStatus = 'Sincronizzazione iniziale in corso...';
    });

    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/timbrature/dipendente/${widget.dipendente.id}',
            ),
            headers: {'x-api-token': ApiConfig.apiToken},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.isEmpty) {
          if (mounted) {
            setState(() {
              _isRestoringFromServer = false;
              _restoreStatus = 'Nessuna timbratura trovata';
            });
          }
          return;
        }

        final List<dynamic> data = jsonDecode(body);
        int inserite = 0;

        for (var item in data) {
          final latitudine = _parseCoordinate(item['latitudine']);
          final longitudine = _parseCoordinate(item['longitudine']);

          final timbratura = Timbratura(
            id: item['id'],
            dipendenteId: item['dipendente_id'],
            tipo: item['tipo'],
            dataOra: DateTime.parse(item['data_ora']),
            sincronizzato: true,
            latitudine: latitudine,
            longitudine: longitudine,
            indirizzo: item['indirizzo'],
          );

          final esiste = await DatabaseService.esisteTimbratura(timbratura.id);
          if (!esiste) {
            await DatabaseService.inserisciTimbratura(timbratura);
            inserite++;
          }
        }

        print(
          'Sincronizzazione dal server completata: ${data.length} timbrature ($inserite inserite)',
        );

        if (mounted) {
          setState(() {
            _isRestoringFromServer = false;
            _restoreStatus = data.isEmpty
                ? 'Nessuna timbratura da ripristinare'
                : 'Sincronizzazione iniziale completata';
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _isRestoringFromServer = false;
          _restoreStatus = 'Sincronizzazione iniziale completata';
        });
      }
    } catch (e) {
      print('Errore sincronizzazione dal server: $e');
      if (mounted) {
        setState(() {
          _isRestoringFromServer = false;
          _restoreStatus = 'Sincronizzazione iniziale fallita';
        });
      }
    }
  }

  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  Future<void> _sincronizza() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final nonSincronizzate =
          await DatabaseService.getTimbratureNonSincronizzate();

      if (nonSincronizzate.isEmpty) {
        if (mounted) {
          setState(() => _isSyncing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nessuna timbratura da sincronizzare'),
              backgroundColor: Colors.blue,
            ),
          );
        }
        return;
      }

      print('Trovate ${nonSincronizzate.length} timbrature da sincronizzare');

      int sincronizzate = 0;
      int fallite = 0;

      for (var timbratura in nonSincronizzate) {
        try {
          print(
            'Invio timbratura ${timbratura.id}: ${timbratura.tipo} del ${timbratura.dataOra}',
          );
          final successo = await ApiService.inviaTimbratura(timbratura);

          if (successo) {
            await DatabaseService.marcaComeSincronizzata(timbratura.id!);
            sincronizzate++;
            print('✓ Timbratura ${timbratura.id} sincronizzata');
          } else {
            fallite++;
            print(
              '✗ Timbratura ${timbratura.id} fallita (risposta API negativa)',
            );
          }
        } catch (e) {
          fallite++;
          print(
            '✗ Errore durante sincronizzazione timbratura ${timbratura.id}: $e',
          );
        }
      }

      if (mounted) {
        setState(() {
          _isSyncing = false;
          _pendingCount = nonSincronizzate.length - sincronizzate;
        });

        if (sincronizzate > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$sincronizzate timbrature sincronizzate'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (fallite > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$fallite timbrature non sincronizzate (controlla connessione)',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Errore generale nella sincronizzazione: $e');
      if (mounted) {
        setState(() => _isSyncing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante la sincronizzazione: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm:ss');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dipendente.nomeCompleto),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Esporta timbrature',
            onPressed: _esportaTimbrature,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Storico',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StoricoScreen(dipendente: widget.dipendente),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Esci',
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);

              // Forza la chiusura dopo un breve delay
              Future.delayed(const Duration(milliseconds: 100), () {
                exit(0);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Orologio
              Text(
                timeFormat.format(_currentTime),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                dateFormat.format(_currentTime),
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _isRestoringFromServer
                      ? Colors.blue.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isRestoringFromServer ? Colors.blue : Colors.green,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isRestoringFromServer ? Icons.sync : Icons.cloud_done,
                      size: 18,
                      color: _isRestoringFromServer
                          ? Colors.blue
                          : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _restoreStatus,
                        style: TextStyle(
                          color: _isRestoringFromServer
                              ? Colors.blue
                              : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Pulsanti timbratura
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimbraButton(
                    'ENTRATA',
                    Colors.green,
                    Icons.login,
                    () => _timbra('entrata'),
                  ),
                  _buildTimbraButton(
                    'USCITA',
                    Colors.red,
                    Icons.logout,
                    () => _timbra('uscita'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimbraButton(
                    'PAUSA',
                    Colors.orange,
                    Icons.coffee,
                    () => _timbra('pausa_inizio'),
                  ),
                  _buildTimbraButton(
                    'FINE PAUSA',
                    Colors.blue,
                    Icons.coffee_maker,
                    () => _timbra('pausa_fine'),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Status sincronizzazione
              if (_pendingCount > 0)
                Card(
                  color: Colors.orange.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, color: Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          '$_pendingCount timbrature da sincronizzare',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_isSyncing)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),

              const SizedBox(height: 24),

              // Pulsante sincronizza manuale
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _sincronizza,
                icon: const Icon(Icons.sync),
                label: const Text('SINCRONIZZA ORA'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimbraButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
