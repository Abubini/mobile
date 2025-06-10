// booking_screen.dart
import 'package:cinema_app/features/tickets/presentation/providers/tickets_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
// import '../../tickets/presentation/providers/tickets_provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/seat_map_widget.dart';
import '../widgets/time_slot_widget.dart';
import '../../../../shared/widgets/seat_info_widget.dart';
import '../../../../shared/widgets/app_button.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    bool _isLoading = false;


    return WillPopScope(
      onWillPop: () async {
        context.go('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(bookingProvider.movieTitle ?? 'Booking'),
          backgroundColor: const Color(0xFF121212),
          foregroundColor: Colors.green,
          actions: [
            IconButton(
              icon: const Icon(Icons.confirmation_number),
              onPressed: () => context.go('/tickets'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Cinema Info
              if (bookingProvider.cinemaName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    bookingProvider.cinemaName!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
              // Calendar Section
              const CalendarWidget(),
              const SizedBox(height: 20),
              
              // Screen Indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF555555), Color(0xFF333333)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'SCREEN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // Seat Map
              const SeatMapWidget(),
              const SizedBox(height: 15),
              
              // Time Selection
              const TimeSlotWidget(),
              const SizedBox(height: 20),
              
              // Seat Info
              const SeatInfoWidget(),
              const SizedBox(height: 20),
              
              // Booking Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    text: 'Reset',
                    backgroundColor: const Color(0xFF2d2d2d),
                    onPressed: bookingProvider.resetSelection,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(width: 10),
                  AppButton(
                    text: 'Book Now (${bookingProvider.selectedSeats.length * bookingProvider.seatPrice} ETB)',
                    backgroundColor: bookingProvider.selectedSeats.isEmpty
                      ? Colors.grey
                      : Colors.green,
                    onPressed: bookingProvider.selectedSeats.isEmpty
                      ? (){}
                      : () async {
                          try {
                            final ticket = await bookingProvider.bookTickets();
                            final ticketsProvider = Provider.of<TicketsProvider>(context, listen: false);
                            await ticketsProvider.addTicket(ticket);
                            if (context.mounted) {
                              context.go('/ticket-detail', extra: ticket);
                              bookingProvider.resetSelection();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}