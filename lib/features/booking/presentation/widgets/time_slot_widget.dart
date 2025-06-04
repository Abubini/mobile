import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class TimeSlotWidget extends StatelessWidget {
  const TimeSlotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(now, bookingProvider.selectedDate);
    final timeSlots = ['09:00', '11:30', '14:00', '16:30', '19:00', '21:30'];

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
        Wrap(
        spacing: 8,
        runSpacing: 8,
        children: timeSlots.map((time) {
          final timeParts = time.split(':');
          final slotDateTime = DateTime(
            bookingProvider.selectedDate.year,
            bookingProvider.selectedDate.month,
            bookingProvider.selectedDate.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
          
          final isPast = slotDateTime.isBefore(now);
          final isActive = bookingProvider.selectedTime == time && !isPast;

          return GestureDetector(
            onTap: isPast ? null : () {
              bookingProvider.selectTime(time);
              bookingProvider.clearSeats(); // Clear seats when time changes
            },
            child: Opacity(
              opacity: isPast ? 0.5 : 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green
                      : const Color(0xFF2d2d2d),
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

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }
}