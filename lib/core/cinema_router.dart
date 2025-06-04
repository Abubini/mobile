import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../cinema_features/cinema_auth/screens/cinema_login_screen.dart';
import '../cinema_features/cinema_auth/screens/cinema_signup_screen.dart';
import '../cinema_features/qr_code/screens/scan_qr_screen.dart';

final cinemaRouter = GoRouter(
  initialLocation: '/cinema/login',
  routes: [
    GoRoute(
      path: '/cinema/login',
      pageBuilder: (context, state) => MaterialPage(
        child: CinemaLoginScreen(),
      ),
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