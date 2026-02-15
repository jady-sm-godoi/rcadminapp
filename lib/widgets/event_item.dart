import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final bool isRegistered;
  final VoidCallback onTap;

  const EventItem({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.isRegistered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Cores baseadas no tema do app (extraídas do RcaDrawer/Login)
    final primaryColor = const Color.fromRGBO(135, 118, 78, 1);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Garante que o InkWell respeite as bordas arredondadas
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha do Título e Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243B55), // Azul escuro do tema
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusTag(isRegistered, primaryColor),
                ],
              ),
              const SizedBox(height: 12),
              
              // Informações de Data e Local
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(bool registered, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: registered ? Colors.green.withValues(alpha: 0.1) : primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: registered ? Colors.green : primaryColor,
          width: 1,
        ),
      ),
      child: Text(
        registered ? 'Inscrito' : 'Disponível',
        style: TextStyle(
          color: registered ? Colors.green[700] : primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}