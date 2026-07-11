import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dipendente.dart';
import '../models/timbratura.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class StoricoScreen extends StatefulWidget {
  final Dipendente dipendente;

  const StoricoScreen({super.key, required this.dipendente});

  @override
  State<StoricoScreen> createState() => _StoricoScreenState();
}

class _StoricoScreenState extends State<StoricoScreen> {
  List<Timbratura> _storico = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _caricaStorico();
  }

  Future<void> _caricaStorico() async {
    setState(() => _isLoading = true);

    // Prova prima a caricare dal server
    final storicoServer = await ApiService.getStorico(widget.dipendente.id);
    
    if (storicoServer.isNotEmpty) {
      setState(() {
        _storico = storicoServer;
        _isLoading = false;
      });
    } else {
      // Se non c'è connessione, carica dal database locale
      final storicoLocale = await DatabaseService.getTutteTimbratureLocali();
      setState(() {
        _storico = storicoLocale.where((t) => t.dipendenteId == widget.dipendente.id).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storico Timbrature'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _storico.isEmpty
              ? const Center(
                  child: Text(
                    'Nessuna timbratura registrata',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _caricaStorico,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _storico.length,
                    itemBuilder: (context, index) {
                      final timbratura = _storico[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getColorForTipo(timbratura.tipo),
                            child: Icon(
                              _getIconForTipo(timbratura.tipo),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            timbratura.tipoLabel,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${dateFormat.format(timbratura.dataOra)} alle ${timeFormat.format(timbratura.dataOra)}',
                          ),
                          trailing: timbratura.sincronizzato
                              ? const Icon(Icons.cloud_done, color: Colors.green, size: 20)
                              : const Icon(Icons.cloud_off, color: Colors.orange, size: 20),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Color _getColorForTipo(String tipo) {
    switch (tipo) {
      case 'entrata':
        return Colors.green;
      case 'uscita':
        return Colors.red;
      case 'pausa_inizio':
        return Colors.orange;
      case 'pausa_fine':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'entrata':
        return Icons.login;
      case 'uscita':
        return Icons.logout;
      case 'pausa_inizio':
        return Icons.coffee;
      case 'pausa_fine':
        return Icons.coffee_maker;
      default:
        return Icons.access_time;
    }
  }
}
