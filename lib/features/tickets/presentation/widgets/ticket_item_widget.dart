import 'package:flutter/material.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import '../../../../shared/widgets/ticket_menu_widget.dart';

class TicketItemWidget extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final GlobalKey qrKey = GlobalKey();

  TicketItemWidget({
    super.key,
    required this.ticket,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1e1e1e),
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.movieName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${ticket.formattedDate} • ${ticket.formattedTime}\n'
                      '${ticket.theater} • Seats: ${ticket.seats.take(5).join(', ')}${ticket.seats.length > 5 ? '...' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              TicketMenuWidget(
                ticket: ticket,
                onDelete: onDelete,
                onReschedule: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reschedule feature coming soon!')),
                  );
                },
                qrKey: qrKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}