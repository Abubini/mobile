import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/cinema_home_screen.dart';
import 'package:cinema_app/features/home/data/models/movie_model.dart';
import 'package:cinema_app/features/home/presentation/providers/home_provider.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cinema_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cinema_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:cinema_app/features/home/presentation/screens/home_screen.dart';
import 'package:cinema_app/features/movie_detail/presentation/screens/movie_detail_screen.dart';
import 'package:cinema_app/features/booking/presentation/screens/booking_screen.dart';
import 'package:cinema_app/features/tickets/presentation/screens/tickets_screen.dart';
import 'package:cinema_app/features/ticket_detail/presentation/screens/ticket_detail_screen.dart';

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
  path: '/cinema/home',
  pageBuilder: (context, state) => MaterialPage(
    child: ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: CinemaHomeScreen(),
    ),
  ),
),
    GoRoute(
      path: '/movie-detail',
      builder: (context, state) => MovieDetailScreen(movie: state.extra as Movie),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
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