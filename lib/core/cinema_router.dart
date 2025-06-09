import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/add_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/cinema_home_screen.dart';
import 'package:cinema_app/cinema_features/cinema_home/presentation/screens/cinema_movie_detail_screen.dart';
import '../cinema_features/cinema_home/presentation/providers/cinema_home_provider.dart';
import '../cinema_features/cinema_auth/screens/cinema_login_screen.dart';
import '../cinema_features/cinema_auth/screens/cinema_signup_screen.dart';
import '../cinema_features/qr_code/screens/scan_qr_screen.dart';

final cinemaRouter = GoRouter(
  initialLocation: '/cinema/login',
  routes: [
    GoRoute(
      path: '/cinema/login',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const CinemaLoginScreen(),
      ),
    ),
    GoRoute(
      path: '/cinema/home',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: ChangeNotifierProvider(
          create: (_) => CinemaHomeProvider(),
          child: const CinemaHomeScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/cinema/movie-detail',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: CinemaMovieDetailScreen(
          movie: state.extra as Map<String, dynamic>,
        ),
      ),
    ),
    GoRoute(
      path: '/cinema/add-movie',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const AddMovieScreen(),
      ),
    ),
    // GoRoute(
    //   path: '/cinema/edit-movie',
    //   pageBuilder: (context, state) => MaterialPage(
    //     key: state.pageKey,
    //     child: AddMovieScreen(
    //       existingMovie: state.extra as Map<String, dynamic>,
    //     ),
    //   ),
    // ),
    GoRoute(
      path: '/cinema/signup',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const CinemaSignupScreen(),
      ),
    ),
    GoRoute(
      path: '/cinema/scan',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ScanQRScreen(),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Route not found: ${state.location}'),
    ),
  ),
);