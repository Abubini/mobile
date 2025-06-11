// Create a new file: cancel_ticket_dialog.dart
import 'package:flutter/material.dart';

class CancelTicketDialog extends StatelessWidget {
  final String movieName;
  final String date;
  final VoidCallback onConfirm;

  const CancelTicketDialog({
    super.key,
    required this.movieName,
    required this.date,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel Ticket'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to cancel your ticket for:'),
          SizedBox(height: 8),
          Text(
            movieName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          Text(
            'This action cannot be undone.',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('No, Keep It'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text('Yes, Cancel Ticket'),
        ),
      ],
    );
  }
}