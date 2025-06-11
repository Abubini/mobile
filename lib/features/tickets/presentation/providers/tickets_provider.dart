import 'package:cinema_app/features/booking/data/repositories/booking_repo.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketsProvider with ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
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
    final bookings = await _bookingRepository.getUserBookings(user.uid);
    _tickets = await Future.wait(bookings.map((booking) async {
      final movieDoc = await _firestore
          .collection('cinemas')
          .doc(booking.cinemaId)
          .collection('movies')
          .doc(booking.movieId)
          .get();
      final cinemaDoc = await _firestore
          .collection('cinemas')
          .doc(booking.cinemaId)
          .get();

      // Format date as dd/MM/yyyy
      final formattedDate = 
          '${booking.date.day.toString().padLeft(2, '0')}/'
          '${booking.date.month.toString().padLeft(2, '0')}/'
          '${booking.date.year}';

      return Ticket(
        id: booking.id ?? booking.movieId,
        movieName: movieDoc['title'] ?? 'Unknown Movie',
        genre: movieDoc['genre'] ?? 'Unknown Genre',
        date: formattedDate, // Use formatted date
        time: booking.time,
        theater: cinemaDoc['name'] ?? 'Unknown Cinema',
        seats: booking.seats,
        cost: '${booking.totalCost} ETB', 
        movieId: booking.movieId, 
        cinemaId: booking.cinemaId,
      );
    }));
    
    _tickets.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  } catch (e) {
    debugPrint('Error loading tickets: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> addTicket(Ticket ticket) async {
    _tickets.insert(0, ticket);
    notifyListeners();
  }

  // Update ticket_provider.dart
Future<void> cancelTicket({
  required String bookingId,
  required String userId,
  required String movieId,
  required String cinemaId,
  required DateTime date,
  required String time,
  required List<String> seats,
}) async {
  try {
    await _bookingRepository.cancelTicket(
      bookingId: bookingId,
      userId: userId,
      movieId: movieId,
      cinemaId: cinemaId,
      date: date,
      time: time,
      seats: seats,
    );
    
    // Remove the ticket from local state
    _tickets.removeWhere((ticket) => ticket.id == bookingId);
    notifyListeners();
  } catch (e) {
    debugPrint('Error cancelling ticket: $e');
    rethrow;
  }
}
}