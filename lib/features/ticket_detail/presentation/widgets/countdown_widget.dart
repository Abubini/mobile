import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final Ticket ticket;

  const CountdownWidget({super.key, required this.ticket});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Duration _remainingTime;
  late DateTime _ticketDateTime;
    bool _isValidDateTime = true;

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _startTimer();
  }

  void _initializeDateTime() {
    try {
      _ticketDateTime = widget.ticket.dateTime;
      _remainingTime = _ticketDateTime.difference(DateTime.now());
      _isValidDateTime = true;
    } catch (e) {
      debugPrint('Error initializing date time: $e');
      _isValidDateTime = false;
      _remainingTime = const Duration();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isValidDateTime) {
        setState(() {
          _remainingTime = _ticketDateTime.difference(DateTime.now());
        });
        if (_remainingTime.inSeconds > 0) {
          _startTimer();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidDateTime) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Invalid date/time',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
          ),
        ),
      );
    }
    // If the event has passed, show "Event passed" message
    if (_remainingTime.isNegative) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Event passed',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeUnit(days.toString().padLeft(2, '0'), 'Days'),
          const SizedBox(width: 8),
          _buildTimeUnit(hours.toString().padLeft(2, '0'), 'Hrs'),
          const SizedBox(width: 8),
          _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'Min'),
          const SizedBox(width: 8),
          _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'Sec'),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}