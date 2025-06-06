import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/add_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/cinema_home_screen.dart';
import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/cinema_movie_detail_screen.dart';
import 'package:cinema_app/features/home/data/models/movie_model.dart';
import '../cinema_features/cinema_home/presentation/providers/cinema_home_provider.dart';
import '../cinema_features/cinema_auth/screens/cinema_login_screen.dart';
import '../cinema_features/cinema_auth/screens/cinema_signup_screen.dart';
import '../cinema_features/qr_code/screens/scan_qr_screen.dart';

final cinemaRouter = GoRouter(
  initialLocation: '/cinema/home',
  routes: [
    GoRoute(
      path: '/cinema/login',
      pageBuilder: (context, state) => MaterialPage(
        child: CinemaLoginScreen(),
      ),
    ),
    GoRoute(
      path: '/cinema/home',
      pageBuilder: (context, state) => MaterialPage(
        child: ChangeNotifierProvider(
          create: (_) => CinemaHomeProvider(), // ✅ Inject the correct provider
          child: const CinemaHomeScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/cinema/movie-detail',
      builder: (context, state) => CinemaMovieDetailScreen(
        movie: state.extra as Movie,
      ),
    ),
    GoRoute(
      path: '/cinema/add-movie',
      builder: (context, state) => const AddMovieScreen(),
    ),
    GoRoute(
      path: '/cinema/signup',
      pageBuilder: (context, state) => MaterialPage(
        child: CinemaSignupScreen(),
      ),
    ),
    GoRoute(
      path: '/cinema/scan',
      pageBuilder: (context, state) => MaterialPage(
        child: ScanQRScreen(),
      ),
    ),
  ],
);
