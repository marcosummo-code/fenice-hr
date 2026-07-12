import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dipendente.dart';
import '../services/api_service.dart';

class NotificheScreen extends StatefulWidget {
  final Dipendente dipendente;
  const NotificheScreen({super.key, required this.dipendente});

  @override
  State<NotificheScreen> createState() => _NotificheScreenState();
}

class _NotificheScreenState extends State<NotificheScreen> {
  List<Map<String, dynamic>> _notifiche = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _caricaNotifiche();
  }

  Future<void> _caricaNotifiche() async {
    setState(() => _isLoading = true);

    final notifiche = await ApiService.getNotificheDipendente(widget.dipendente.id);

    if (mounted) {
      setState(() {
        _notifiche = notifiche;
        _isLoading = false;
      });
    }
  }

  Future<void> _segnaComeLetta(int id, int index) async {
    final successo = await ApiService.segnaNotificaComeLetta(id);
    if (successo && mounted) {
      setState(() {
        _notifiche[index]['letto'] = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie Notifiche'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Aggiorna',
            onPressed: _caricaNotifiche,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifiche.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nessuna notifica',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _caricaNotifiche,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifiche.length,
                    itemBuilder: (context, index) {
                      final notifica = _notifiche[index];
                      final isLetta = notifica['letto'] == 1;
                      final tipo = notifica['tipo'] as String? ?? '';
                      final titolo = notifica['titolo'] as String? ?? '';
                      final messaggio = notifica['messaggio'] as String? ?? '';
                      final creatoIl = notifica['creato_il'] as String?;

                      Color tipoColor;
                      IconData tipoIcon;
                      switch (tipo) {
                        case 'ferie_approvata':
                          tipoColor = Colors.green;
                          tipoIcon = Icons.check_circle;
                          break;
                        case 'ferie_rifiutata':
                          tipoColor = Colors.red;
                          tipoIcon = Icons.cancel;
                          break;
                        case 'ferie_richiesta':
                          tipoColor = Colors.amber.shade700;
                          tipoIcon = Icons.hourglass_top;
                          break;
                        default:
                          tipoColor = Colors.blue;
                          tipoIcon = Icons.notifications;
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isLetta ? Colors.white : tipoColor.withOpacity(0.05),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: tipoColor,
                            child: Icon(tipoIcon, color: Colors.white),
                          ),
                          title: Text(
                            titolo,
                            style: TextStyle(
                              fontWeight: isLetta ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(messaggio),
                              const SizedBox(height: 8),
                              Text(
                                creatoIl != null ? dateFormat.format(DateTime.parse(creatoIl)) : '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          trailing: isLetta
                              ? const Icon(Icons.check, color: Colors.green, size: 20)
                              : IconButton(
                                  icon: const Icon(Icons.mark_email_read, color: Colors.blue),
                                  tooltip: 'Segna come letta',
                                  onPressed: () => _segnaComeLetta(notifica['id'], index),
                                ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
