import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../features/tickets/data/models/ticket_model.dart';

class QRCodeWidget extends StatelessWidget {
  final Ticket ticket;

  const QRCodeWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = ticket.isValid;
    final validity = isValid ? '✅ Valid ticket' : '❌ Expired ticket';

    // Create a structured ticket data string for the QR code
    final ticketData = '''
CINEMA TICKET
────────────────
🎬 Movie: ${ticket.movieName}
🎭 Genre: ${ticket.genre}
📅 Date: ${ticket.formattedDate}
🕒 Time: ${ticket.formattedTime}
📍 Theater: ${ticket.theater}
💺 Seats: ${ticket.seats.join(', ')}
💰 Total: ${ticket.cost}
────────────────
ID: ${ticket.id}
Status: $validity
Scanned: ${now.toIso8601String()}
''';

    return Column(
      children: [
        QrImageView(
          data: ticketData,
          version: QrVersions.auto,
          size: 180,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          validity,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}