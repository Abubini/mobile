import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../features/tickets/data/models/ticket_model.dart';

class QRCodeWidget extends StatelessWidget {
  final Ticket ticket;

  const QRCodeWidget({super.key, required this.ticket});

  @override
Widget build(BuildContext context) {
  final now = DateTime.now();
  final ticketDateTime = DateTime(
    DateTime.parse(ticket.date).year,
    DateTime.parse(ticket.date).month,
    DateTime.parse(ticket.date).day,
    int.parse(ticket.time.split(':')[0]),
    int.parse(ticket.time.split(':')[1]),
  );
  final isValid = ticketDateTime.isAfter(now);

  final ticketData = {
    'movie': ticket.movieName,
    'date': ticket.date,
    'time': ticket.time,
    'seats': ticket.seats,
    'id': ticket.id,
    'isValid': isValid,
    'validationDate': now.toIso8601String(),
  };

  return QrImageView(
    data: ticketData.toString(),
    version: QrVersions.auto,
    size: 130,
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
  );
}
}