import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class SeatMapWidget extends StatelessWidget {
  const SeatMapWidget({super.key});

  @override
Widget build(BuildContext context) {
  final bookingProvider = Provider.of<BookingProvider>(context);
  final takenSeats = bookingProvider.getTakenSeats().toSet();

  return Column(
    children: [
      if (bookingProvider.selectedTime == null)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Please select date and time first',
            style: TextStyle(color: Colors.grey),
          ),
        )
      else
        Column(
          children: [
            for (int row = 0; row < 10; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int col = 1; col <= 12; col++)
                      if (col == 5 || col == 9)
                        const SizedBox(width: 6)
                      else
                        _buildSeat(
                          context,
                          row: row,
                          col: col,
                          isTaken: takenSeats.contains('${String.fromCharCode(65 + row)}$col'),
                          bookingProvider: bookingProvider,
                        ),
                  ],
                ),
              ),
          ],
        ),
    ],
  );
}

  Widget _buildSeat(
    BuildContext context, {
    required int row,
    required int col,
    required bool isTaken,
    required BookingProvider bookingProvider,
  }) {
    final seatId = '${String.fromCharCode(65 + row)}$col';
    final isSelected = bookingProvider.selectedSeats.contains(seatId);

    return GestureDetector(
      onTap: isTaken
          ? null
          : () => bookingProvider.toggleSeat(seatId),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          color: isTaken
              ? const Color(0xFFFF5722).withOpacity(0.7)
              : isSelected
                  ? Colors.green
                  : const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}