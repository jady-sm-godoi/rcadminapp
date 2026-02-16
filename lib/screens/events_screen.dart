import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/service/event_service.dart';
import 'package:rcadminapp/widgets/event_item.dart';
import 'package:rcadminapp/widgets/rca_bottom_modal.dart';
import 'package:rcadminapp/widgets/rca_background.dart';
import 'package:rcadminapp/widgets/rca_drawer.dart';
import 'package:rcadminapp/widgets/rca_header_bar.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<dynamic>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Auth>(context, listen: false);
    _eventsFuture = EventService().getEvents(auth);
  }

  String formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: RcaHeaderBar(subtitle: 'Eventos abertos',),
      endDrawer: RcaDrawer(),
      body: RcaBackground(
        addPaddingTop: true,
        child: FutureBuilder<List<dynamic>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erro ao carregar eventos'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final auth = Provider.of<Auth>(context, listen: false);
                          _eventsFuture = EventService().getEvents(auth);
                        });
                      },
                      child: const Text('Tentar novamente'),
                    )
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum evento encontrado.'));
            }

            final events = snapshot.data!;
            debugPrint('Lista de Eventos na Tela: $events');

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final registered = event['registered'] as Map<String, dynamic>?;
                final bool isRegistered = registered != null;
                final status = registered?['status'] as String?;

                final startDate = formatDate(event['date'] ?? '');
                final endDate = formatDate(event['end_date'] ?? '');
                final dateDisplay = startDate == endDate ? startDate : '$startDate - $endDate';

                return EventItem(
                  title: event['activity'] ?? '',
                  date: dateDisplay,
                  location: event['center'] ?? '',
                  isRegistered: isRegistered,
                  statusLabel: status,
                  onTap: () {
                    if (isRegistered) {
                      _showRegistrationDetails(context, event['id']);
                    } else {
                      // Navegar para o fluxo de inscrição
                      // Navigator.of(context).pushNamed('/event_details', arguments: event);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Clicou em: ${event['activity']}')),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showRegistrationDetails(BuildContext context, int eventId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final registrations = await EventService().getRegistrations(auth);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Fecha o loading

      // Encontra a inscrição correspondente ao evento clicado
      final matches = registrations.where(
        (reg) => reg['event'] != null && reg['event']['event_id'] == eventId,
      );
      final registration = matches.isNotEmpty ? matches.first : null;

      if (registration != null) {
        _openRegistrationModal(context, registration);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Detalhes da inscrição não encontrados.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Garante fechar o loading em caso de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  void _openRegistrationModal(BuildContext context, Map<String, dynamic> data) {
    RcaBottomModal.show(
      context: context,
      title: 'Inscrição realizada',
      content: Column(
        children: [
          _buildDetailRow('Evento', data['event']?['name'] ?? ''),
          _buildDetailRow('Local', data['event']?['center'] ?? ''),
          _buildDetailRow('Hospedagem', data['lodge'] ?? ''),
          _buildDetailRow('Chegada', data['arrival_time'] ?? ''),
          _buildDetailRow('Partida', data['departure_time'] ?? ''),
          _buildDetailRow('Valor', 'R\$ ${data['value']}'),
          _buildDetailRow('Status', data['order']?['status'] ?? ''),
          if (data['observations'] != null && data['observations'].toString().isNotEmpty)
            _buildDetailRow('Observações', data['observations'].toString()),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(135, 118, 78, 1),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}