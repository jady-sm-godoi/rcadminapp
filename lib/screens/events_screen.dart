import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rcadminapp/config/app_config.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/widgets/event_item.dart';
import 'package:rcadminapp/widgets/rca_bottom_modal.dart';
import 'package:rcadminapp/widgets/rca_background.dart';
import 'package:rcadminapp/widgets/rca_drawer.dart';
import 'package:rcadminapp/widgets/rca_header_bar.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de dados (depois virá da API)
    final List<Map<String, dynamic>> events = [
      {
        "activity": "Conferência de Renovação",
        "activity_type": "CONFERENCE",
        "center_id": 1,
        "center": "CCPA - Jarinú",
        "center_abbr": "CCPA",
        "registered": {
          "status": "Inscrito",
          "self_registered": true
        },
        "id": 101,
        "description": "Evento de renovação",
        "date": "2026-02-21",
        "end_date": "2026-02-22",
        "deadline": "2026-02-20T14:15:22Z",
        "ref_value": 100,
        "min_value": 50,
        "hash_id": "b0e08c68-..."
      },
      {
        "activity": "Conferência Especial",
        "activity_type": "CONFERENCE",
        "center_id": 2,
        "center": "Brasilia - DF",
        "center_abbr": "BSB",
        "registered": {
          "status": "Pendente",
          "self_registered": false
        },
        "id": 102,
        "description": "Evento especial",
        "date": "2026-04-11",
        "end_date": "2026-04-12",
        "deadline": "2026-04-10T14:15:22Z",
        "ref_value": 100,
        "min_value": 50,
        "hash_id": "b0e08c68-..."
      },
    ];

    String formatDate(String dateStr) {
      try {
        final parts = dateStr.split('-');
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      } catch (e) {
        return dateStr;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: RcaHeaderBar(subtitle: 'Eventos abertos',),
      endDrawer: RcaDrawer(),
      body: RcaBackground(
        addPaddingTop: true,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final registered = event['registered'] as Map<String, dynamic>;
            final isRegistered = registered['self_registered'] as bool;
            final status = registered['status'] as String?;

            final startDate = formatDate(event['date']);
            final endDate = formatDate(event['end_date']);
            final dateDisplay = startDate == endDate ? startDate : '$startDate - $endDate';

            return EventItem(
              title: event['activity'],
              date: dateDisplay,
              location: event['center'],
              isRegistered: isRegistered,
              statusLabel: status,
              onTap: () {
                if (status == 'Inscrito') {
                  _showRegistrationDetails(context, event['id']);
                  print('status: $status');
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
    print('eventId: $eventId');
    try {
      // SIMULAÇÃO: Delay de rede
      await Future.delayed(const Duration(seconds: 1));

      // SIMULAÇÃO: Dados mockados
      final Map<String, dynamic> mockData = {
        "success": true,
        "data": [
          {
            "event": {
              "event_id": 101, // ID correspondente ao evento mockado na lista
              "name": "Conferência de Renovação",
              "type": "CONFERENCE",
              "start_date": "2026-02-21",
              "end_date": "2026-02-22",
              "center": "CCPA - Jarinú",
              "center_abbr": "CCPA"
            },
            "order": {
              "order_id": 888,
              "status": "Confirmado",
              "self_registered": true
            },
            "lodge": "Alojamento B",
            "arrival_time": "18:00",
            "departure_time": "13:00",
            "id": 1,
            "no_stairs": false,
            "no_bunk": false,
            "no_gluten": true,
            "take_meals": true,
            "staff": "N/A",
            "value": 150.00,
            "observations": "Sem glúten, por favor."
          }
        ]
      };

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Fecha o loading

      if (mockData['success'] == true) {
          final List registrations = mockData['data'];
          print('registrations: $registrations');
          // Encontra a inscrição correspondente ao evento clicado
          final matches = registrations.where(
            (reg) => reg['event'] != null && reg['event']['event_id'] == eventId,
          );
          final registration = matches.isNotEmpty ? matches.first : null;

          print('registration: $registration');
          if (registration != null) {
            _openRegistrationModal(context, registration);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Simulação: Detalhes da inscrição não encontrados.')),
            );
          }
      }
    } catch (e) {
      if (context.mounted) {
        // Navigator.of(context).pop(); // Removido pois fechamos antes na simulação
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