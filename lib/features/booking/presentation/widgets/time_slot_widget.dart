// time_slot_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class TimeSlotWidget extends StatelessWidget {
  const TimeSlotWidget({super.key});

  @override
Widget build(BuildContext context) {
  final bookingProvider = Provider.of<BookingProvider>(context);
  final availableTimes = bookingProvider.getAvailableTimes();
  final now = DateTime.now();
  final isToday = bookingProvider.selectedDate != null && 
      DateUtils.isSameDay(now, bookingProvider.selectedDate!);

  return Column(
    children: [
      const Text(
        'SELECT SHOWTIME',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 10),
      if (availableTimes.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'No available times for selected date',
            style: TextStyle(color: Colors.grey),
          ),
        )
      else
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableTimes.map((time) {
            final isPast = isToday && _isTimePast(time, now);
            final isActive = bookingProvider.selectedTime == time && !isPast;

            return GestureDetector(
              onTap: isPast ? null : () => bookingProvider.selectTime(time),
              child: Opacity(
                opacity: isPast ? 0.5 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : const Color(0xFF2d2d2d),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _formatTime(time),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
    ],
  );
}

  bool _isTimePast(String time, DateTime now) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return now.hour > hour || (now.hour == hour && now.minute > minute);
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }
}