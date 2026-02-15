import 'package:flutter/material.dart';
import 'package:rcadminapp/widgets/event_item.dart';
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
        'title': 'Conferência de Renovação',
        'date': '21/02/2026 - 22/02/2026',
        'location': 'CCPA - Jarinú',
        'isRegistered': true,
      },
      {
        'title': 'Conferência de Renovação',
        'date': '21/02/2026 - 22/02/2026',
        'location': 'Brasilia - DF',
        'isRegistered': false,
      },
      {
        'title': 'Conferência de Especial',
        'date': '11/04/2026 - 12/04/2026',
        'location': 'Manaus - AM',
        'isRegistered': false,
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: RcaHeaderBar(),
      endDrawer: RcaDrawer(),
      body: RcaBackground(
        addPaddingTop: true,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventItem(
              title: event['title'],
              date: event['date'],
              location: event['location'],
              isRegistered: event['isRegistered'],
              onTap: () {
                // Navegar para o fluxo de inscrição
                // Navigator.of(context).pushNamed('/event_details', arguments: event);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Clicou em: ${event['title']}')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}