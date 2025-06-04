import 'package:cinema_app/features/ticket_detail/presentation/widgets/countdown_widget.dart';
import 'package:cinema_app/features/ticket_detail/presentation/widgets/qr_code_widget.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
import '../../../../shared/widgets/app_button.dart';

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailScreen({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final ticket = GoRouterState.of(context).extra as Ticket;

    return WillPopScope(
      onWillPop: () async {
        context.go('/tickets');
        return false; // Prevent default back behavior
      },

    child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Ticket',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildTicketRow('Movie', ticket.movieName),
                  _buildTicketRow('Genre', ticket.genre),
                  
                  Row(
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ticket.formattedDate,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, size: 16, color: Colors.green),
                        onPressed: () => _showCalendar(context, ticket.date),
                      ),
                    ],
                  ),
                  
                  _buildTicketRow('Time', ticket.formattedTime),
                  
                  // Countdown
                  CountdownWidget(targetDate: ticket.dateTime),
                  
                  _buildTicketRow('Theater', ticket.theater),
                  _buildTicketRow('Seats',
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: ticket.seats.map((seat) => Text(seat,style: const TextStyle(
                        color: Colors.green, // Explicit green color for seats
                        fontSize: 13,       // Match the size of other ticket info
                      ),)).toList(),
                    ),
                    isWidget: true,),
                  _buildTicketRow('Cost', ticket.cost),
                  
                  // QR Code
                  const SizedBox(height: 12),
                  Center(
                    child: QRCodeWidget(ticket: ticket),
                  ),
                  // Add this widget after the QR code section:
                  Builder(
                    builder: (context) {
                      final now = DateTime.now();
                      final ticketDateTime = DateTime(
                        DateTime.parse(ticket.date).year,
                        DateTime.parse(ticket.date).month,
                        DateTime.parse(ticket.date).day,
                        int.parse(ticket.time.split(':')[0]),
                        int.parse(ticket.time.split(':')[1]),
                      );
                      final isValid = ticketDateTime.isAfter(now);

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          isValid ? 'Valid Ticket' : 'Expired Ticket',
                          style: TextStyle(
                            color: isValid ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '×',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
  // Try to pop first, if that fails, go to tickets page
                  if (!context.canPop()) {
                    context.go('/tickets');
                  } else {
                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildTicketRow(String label, dynamic value, {bool isWidget = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isWidget)
            Flexible(child: value as Widget)
          else
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  void _showCalendar(BuildContext context, String date) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1e1e1e),
          title: const Text(
            'Movie Date',
            style: TextStyle(color: Colors.green),
          ),
          content: SizedBox(
            width: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_getMonthName(DateTime.parse(date).month)} ${DateTime.parse(date).year}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                _buildCalendarGrid(date),
                const SizedBox(height: 15),
                AppButton(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildCalendarGrid(String date) {
    final ticketDate = DateTime.parse(date);
    final firstDay = DateTime(ticketDate.year, ticketDate.month, 1);
    final daysInMonth = DateTime(ticketDate.year, ticketDate.month + 1, 0).day;
    
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemCount: dayNames.length + firstDay.weekday % 7 + daysInMonth,
      itemBuilder: (context, index) {
        if (index < dayNames.length) {
          // Day headers
          return Center(
            child: Text(
              dayNames[index],
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          );
        } else if (index < dayNames.length + firstDay.weekday % 7) {
          // Empty cells before first day
          return const SizedBox();
        } else {
          // Days of month
          final day = index - dayNames.length - firstDay.weekday % 7 + 1;
          return Container(
            decoration: BoxDecoration(
              color: day == ticketDate.day ? Colors.green : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: day == ticketDate.day ? Colors.white : Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}