import 'package:flutter/material.dart';
import 'package:cinema_app/core/constants/app_colors.dart';

class CancelTicketDialog extends StatelessWidget {
  final String movieName;
  final String date;
  final String time;
  final String seats;
  final VoidCallback onConfirm;

  const CancelTicketDialog({
    super.key,
    required this.movieName,
    required this.date,
    required this.time,
    required this.seats,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cancel Ticket',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Movie Info
            Text(
              movieName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Details
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  '$date at $time',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            Row(
              children: [
                Icon(Icons.chair, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  'Seats: $seats',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Warning
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone. A cancellation fee may apply.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textMuted,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('KEEP TICKET'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                  child: const Text('CONFIRM'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}