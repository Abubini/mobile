// tickets_provider.dart
import 'package:cinema_app/features/booking/data/repositories/booking_repo.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../../booking/data/repositories/booking_repo.dart';
// import '../models/ticket_model.dart';

class TicketsProvider with ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Ticket> _tickets = [];
  bool _isLoading = false;

  List<Ticket> get tickets => _tickets;
  bool get isLoading => _isLoading;

  Future<void> loadUserTickets() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Convert bookings to tickets
      final bookings = await _bookingRepository.getUserBookings(user.uid);
      _tickets = await Future.wait(bookings.map((booking) async {
        final movieDoc = await FirebaseFirestore.instance
            .collection('cinemas')
            .doc(booking.cinemaId)
            .collection('movies')
            .doc(booking.movieId)
            .get();
        final cinemaDoc = await FirebaseFirestore.instance
            .collection('cinemas')
            .doc(booking.cinemaId)
            .get();

        return Ticket(
          id: booking.movieId, // You might want to use a different ID here
          movieName: movieDoc['title'],
          genre: movieDoc['genre'],
          date: '${booking.date.day}/${booking.date.month}/${booking.date.year}',
          time: booking.time,
          theater: cinemaDoc['name'],
          seats: booking.seats,
          cost: '${booking.totalCost} ETB',
        );
      }));
    } catch (e) {
      print('Error loading tickets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTicket(Ticket ticket) async {
    _tickets.insert(0, ticket);
    notifyListeners();
  }
}