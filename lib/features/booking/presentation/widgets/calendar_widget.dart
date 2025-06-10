// calendar_widget.dart
import 'package:cinema_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final availableDates = bookingProvider.getAvailableDates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (availableDates.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.green),
                onPressed: () => _showDatePicker(context, bookingProvider, availableDates),
              ),
          ],
        ),
        const SizedBox(height: 10),
        _buildMiniCalendar(bookingProvider, availableDates),
      ],
    );
  }

  Widget _buildMiniCalendar(BookingProvider bookingProvider, List<DateTime> availableDates) {
    if (availableDates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'No available dates',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableDates.length,
        itemBuilder: (context, index) {
          final date = availableDates[index];
          final isSelected = bookingProvider.selectedDate != null && 
              DateUtils.isSameDay(date, bookingProvider.selectedDate!);

          return GestureDetector(
            onTap: () => bookingProvider.selectDate(date),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green
                    : const Color(0xFF2d2d2d),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekday(date.weekday),
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDatePicker(
    BuildContext context, 
    BookingProvider bookingProvider,
    List<DateTime> availableDates,
  ) {
    final now = DateTime.now();
    
    showDatePicker(
      context: context,
      initialDate: bookingProvider.selectedDate ?? availableDates.first,
      firstDate: availableDates.first,
      lastDate: availableDates.last,
      selectableDayPredicate: (DateTime day) {
        return availableDates.any((date) => DateUtils.isSameDay(date, day));
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        bookingProvider.selectDate(pickedDate);
      }
    });
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}