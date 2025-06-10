// booking_repository.dart
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
// import '../../tickets/data/models/ticket_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ShowTime>> getShowTimes(String movieId, String cinemaId) async {
  try {
    final doc = await _firestore
        .collection('cinemas')
        .doc(cinemaId)
        .collection('movies')
        .doc(movieId)
        .get();

    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>;
    final showTimes = data['showTimes'] as List<dynamic>? ?? [];
    
    return showTimes.map((st) {
      final showTimeData = st as Map<String, dynamic>;
      return ShowTime(
        date: DateTime.parse(showTimeData['date']),
        time: showTimeData['time'] as String,
        bookedSeats: List<String>.from(showTimeData['bookedSeats'] ?? []),
        price: data['cost']?.toDouble() ?? 0.0,
      );
    }).where((st) => st.date.isAfter(DateTime.now())).toList();
  } catch (e) {
    print('Error fetching show times: $e');
    return [];
  }
}

  Future<Ticket> bookTickets({
    required String movieId,
    required String cinemaId,
    required DateTime date,
    required String time,
    required List<String> seats,
    required double seatPrice,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Create booking document in user's subcollection
      final bookingRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .add({
          'movieId': movieId,
          'cinemaId': cinemaId,
          'date': date.toIso8601String(),
          'time': time,
          'seats': seats,
          'totalCost': seats.length * seatPrice,
          'userId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      

      // Also store in global bookings collection for admin purposes
      await _firestore.collection('bookings').add(
        Booking(
          movieId: movieId,
          cinemaId: cinemaId,
          date: date,
          time: time,
          seats: seats,
          totalCost: seats.length * seatPrice,
          userId: user.uid,
        ).toMap(),
      );

      // Update showtime with booked seats
      final showTimeRef = _firestore
          .collection('cinemas')
          .doc(cinemaId)
          .collection('movies')
          .doc(movieId)
          .collection('showTimes')
          .doc('${date.year}-${date.month}-${date.day}-$time');

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(showTimeRef);
        if (snapshot.exists) {
          final currentSeats = List<String>.from(snapshot.data()!['bookedSeats'] ?? []);
          transaction.update(showTimeRef, {
            'bookedSeats': [...currentSeats, ...seats],
          });
        }
      });

      // Get movie and cinema details for ticket
      final cinemaDoc = await _firestore.collection('cinemas').doc(cinemaId).get();
      final movieDoc = cinemaDoc['movies'][movieId];

      return Ticket(
      id: bookingRef.id,
      movieName: movieDoc['title'],
      genre: movieDoc['genre'],
      date: '${date.day}/${date.month}/${date.year}',
      time: time,
      theater: cinemaDoc['name'],
      seats: seats,
      cost: '${seats.length * seatPrice} ETB',
    );
    } catch (e) {
      print('Error booking tickets: $e');
      throw Exception('Failed to book tickets');
    }
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Booking(
          movieId: data['movieId'],
          cinemaId: data['cinemaId'],
          date: (data['date'] as Timestamp).toDate(),
          time: data['time'],
          seats: List<String>.from(data['seats']),
          totalCost: data['totalCost'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }
}