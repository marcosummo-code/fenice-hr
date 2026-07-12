import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../models/dipendente.dart';
import '../services/database_service.dart';
import '../models/timbratura.dart';

class MappaScreen extends StatefulWidget {
  final Dipendente dipendente;
  const MappaScreen({super.key, required this.dipendente});

  @override
  State<MappaScreen> createState() => _MappaScreenState();
}

class _MappaScreenState extends State<MappaScreen> {
  List<Timbratura> _timbrature = [];
  bool _isLoading = true;
  final MapController _mapController = MapController();
  int _filtroGiorni = 30;

  @override
  void initState() {
    super.initState();
    _caricaTimbrature();
  }

  Future<void> _caricaTimbrature() async {
    setState(() => _isLoading = true);

    final tutte = await DatabaseService.getTutteTimbratureLocali();
    final mie = tutte.where((t) => t.dipendenteId == widget.dipendente.id).toList();

    // Filtra per periodo e solo quelle con coordinate
    final dataLimite = DateTime.now().subtract(Duration(days: _filtroGiorni));
    final conCoordinate = mie
        .where((t) =>
            t.latitudine != null &&
            t.longitudine != null &&
            t.dataOra.isAfter(dataLimite))
        .toList();

    // Ordina per data decrescente
    conCoordinate.sort((a, b) => b.dataOra.compareTo(a.dataOra));

    if (mounted) {
      setState(() {
        _timbrature = conCoordinate;
        _isLoading = false;
      });

      // Centra la mappa sulla prima timbratura
      if (conCoordinate.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(
            LatLng(conCoordinate.first.latitudine!, conCoordinate.first.longitudine!),
            14.0,
          );
        });
      }
    }
  }

  Color _colorePerTipo(String tipo) {
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

  IconData _iconaPerTipo(String tipo) {
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
        return Icons.location_on;
    }
  }

  void _mostraDettaglio(Timbratura t) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _colorePerTipo(t.tipo),
                  child: Icon(_iconaPerTipo(t.tipo), color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.tipoLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dateFormat.format(t.dataOra)} alle ${timeFormat.format(t.dataOra)}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            if (t.indirizzo != null && t.indirizzo!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.indirizzo!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.gps_fixed, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Lat: ${t.latitudine?.toStringAsFixed(6)}, Lng: ${t.longitudine?.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  t.sincronizzato ? Icons.cloud_done : Icons.cloud_off,
                  size: 20,
                  color: t.sincronizzato ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  t.sincronizzato ? 'Sincronizzata sul server' : 'Solo in locale',
                  style: TextStyle(
                    fontSize: 12,
                    color: t.sincronizzato ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mappa Timbrature'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtra periodo',
            onSelected: (value) {
              setState(() => _filtroGiorni = value);
              _caricaTimbrature();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('Ultimi 7 giorni')),
              const PopupMenuItem(value: 30, child: Text('Ultimi 30 giorni')),
              const PopupMenuItem(value: 90, child: Text('Ultimi 3 mesi')),
              const PopupMenuItem(value: 365, child: Text('Ultimo anno')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Aggiorna',
            onPressed: _caricaTimbrature,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _timbrature.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nessuna timbratura con coordinate',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Le timbrature effettuate con GPS attivo\nappariranno sulla mappa',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Mappa
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _timbrature.isNotEmpty
                            ? LatLng(
                                _timbrature.first.latitudine!,
                                _timbrature.first.longitudine!,
                              )
                            : const LatLng(45.789, 12.985),
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'hr.app',
                        ),
                        MarkerLayer(
                          markers: _timbrature.map((t) {
                            return Marker(
                              point: LatLng(t.latitudine!, t.longitudine!),
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () => _mostraDettaglio(t),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _colorePerTipo(t.tipo),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _iconaPerTipo(t.tipo),
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    // Lista timbrature in basso
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const Icon(Icons.list, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Timbrature (${_timbrature.length})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Ultimi $_filtroGiorni giorni',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _timbrature.length,
                                itemBuilder: (context, index) {
                                  final t = _timbrature[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: _colorePerTipo(t.tipo),
                                      child: Icon(
                                        _iconaPerTipo(t.tipo),
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      t.tipoLabel,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${dateFormat.format(t.dataOra)} • ${t.indirizzo ?? "Posizione non disponibile"}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      _mapController.move(
                                        LatLng(t.latitudine!, t.longitudine!),
                                        16.0,
                                      );
                                      _mostraDettaglio(t);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
