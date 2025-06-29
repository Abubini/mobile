import 'package:cinema_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:cinema_app/features/home/data/models/movie_model.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cinema_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:cinema_app/features/home/presentation/screens/home_screen.dart';
import 'package:cinema_app/features/movie_detail/presentation/screens/movie_detail_screen.dart';
import 'package:cinema_app/features/booking/presentation/screens/booking_screen.dart';
import 'package:cinema_app/features/tickets/presentation/screens/tickets_screen.dart';
import 'package:cinema_app/features/ticket_detail/presentation/screens/ticket_detail_screen.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/movie-detail',
      builder: (context, state) => MovieDetailScreen(movie: state.extra as Movie),
    ),
    // In router.dart
// In router.dart
GoRoute(
  path: '/booking',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    final movie = extra['movie'] as Movie;
    final cinema = extra['cinema'] as Cinema;
    
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: Builder(
        builder: (context) {
          final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
          
          return FutureBuilder(
            future: bookingProvider.initializeBooking(
              movie.id,
              cinema.id,
              movie.title,
              cinema.name,
              movie.cost,
            ),
            builder: (context, snapshot) {
              // Show loading while initializing
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFF121212),
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // Show error if any
              if (snapshot.hasError) {
                return Scaffold(
                  backgroundColor: const Color(0xFF121212),
                  appBar: AppBar(
                    title: const Text('Booking'),
                    backgroundColor: const Color(0xFF121212),
                    foregroundColor: Colors.green,
                  ),
                  body: Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }

              // Check if we have showtimes
              final hasShowtimes = bookingProvider.getAvailableDates().isNotEmpty;
              
              return Scaffold(
                backgroundColor: const Color(0xFF121212),
                // appBar: AppBar(
                //   title: Text(hasShowtimes ? 'Book Tickets' : 'No Showtimes'),
                //   backgroundColor: const Color(0xFF121212),
                //   foregroundColor: Colors.green,
                // ),
                body: hasShowtimes 
                    ? const BookingScreen()
                    : const Center(
                        child: Text(
                          'No available showtimes for this movie',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  },
),
    GoRoute(
      path: '/tickets',
      builder: (context, state) => const TicketsScreen(),
    ),
    GoRoute(
      path: '/ticket-detail',
      builder: (context, state) => TicketDetailScreen(ticket: state.extra as Ticket),
    ),
  ],
);