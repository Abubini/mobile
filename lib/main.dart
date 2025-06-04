import 'package:cinema_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:cinema_app/features/home/data/models/movie_model.dart';
import 'package:cinema_app/features/home/presentation/providers/home_provider.dart';
import 'package:cinema_app/features/tickets/presentation/providers/tickets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => HomeProvider()..fetchMovies(),
        ),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProxyProvider<BookingProvider, TicketsProvider>(
      create: (context) => TicketsProvider(context.read<BookingProvider>()),
      update: (context, bookingProvider, ticketsProvider) => 
        ticketsProvider ?? TicketsProvider(bookingProvider),
    ),
        Provider<List<Movie>>(create: (_) => []),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cinema Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      routerConfig: router,
    );
  }
}