import 'package:cinema_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final today = DateTime.now();

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
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.green),
              onPressed: () => _showDatePicker(context, bookingProvider),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildMiniCalendar(bookingProvider, today),
      ],
    );
  }

  Widget _buildMiniCalendar(BookingProvider bookingProvider, DateTime today) {
    final dates = List.generate(5, (index) => today.add(Duration(days: index - 2)));

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.day == bookingProvider.selectedDate.day &&
              date.month == bookingProvider.selectedDate.month;

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

  void _showDatePicker(BuildContext context, BookingProvider bookingProvider) {
  final now = DateTime.now();
  
  showDatePicker(
    context: context,
    initialDate: bookingProvider.selectedDate.isAfter(now) 
        ? bookingProvider.selectedDate 
        : now,
    firstDate: now,
    lastDate: now.add(const Duration(days: 30)),
    selectableDayPredicate: (DateTime day) {
      return day.isAfter(now.subtract(const Duration(days: 1)));
    },
    // ... rest of the code
  ).then((pickedDate) {
    if (pickedDate != null) {
      bookingProvider.selectDate(pickedDate);
      bookingProvider.clearSeats(); // Clear seats when date changes
    }
  });
}

  String _getWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}