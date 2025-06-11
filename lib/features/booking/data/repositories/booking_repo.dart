// booking_repository.dart
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ShowTime>> getShowTimes(String movieId, String cinemaId) async {
    try {
      // ✅ Access movies as subcollection
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
      // 1. Create booking document in user's subcollection
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

      // 2. Also store in global bookings collection for admin purposes
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

      // 3. Update showtime with booked seats in the movie subcollection
      final movieRef = _firestore
          .collection('cinemas')
          .doc(cinemaId)
          .collection('movies')
          .doc(movieId);
          
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(movieRef);
        
        if (!snapshot.exists) {
          throw Exception('Movie document not found');
        }
        
        final data = snapshot.data();
        if (data == null || !data.containsKey('showTimes')) {
          throw Exception('ShowTimes not found for movie');
        }

        final showTimes = List<dynamic>.from(data['showTimes'] as List);

        // Update the specific showtime
        final updatedShowTimes = showTimes.map((st) {
          try {
            final showTime = Map<String, dynamic>.from(st as Map<String, dynamic>);
            final showTimeDate = showTime['date'] as String?;
            final showTimeTime = showTime['time'] as String?;
            
            // ✅ Better date comparison
            final targetDateString = date.toIso8601String().split('T')[0];
            
            if (showTimeDate == targetDateString && showTimeTime == time) {
              final bookedSeats = List<String>.from(showTime['bookedSeats'] as List? ?? []);
              return {
                ...showTime,
                'bookedSeats': [...bookedSeats, ...seats],
              };
            }
            return showTime;
          } catch (e) {
            print('Error processing showtime: $e');
            return st;
          }
        }).toList();

        // ✅ Update the movie document with updated showTimes
        transaction.update(movieRef, {'showTimes': updatedShowTimes});
      });

      // 4. Get ticket details from movie subcollection
      final movieDoc = await _firestore
          .collection('cinemas')
          .doc(cinemaId)
          .collection('movies')
          .doc(movieId)
          .get();
          
      if (!movieDoc.exists) {
        throw Exception('Failed to load movie details');
      }

      final movieData = movieDoc.data()!;
      
      // Get cinema name for the ticket
      final cinemaDoc = await _firestore.collection('cinemas').doc(cinemaId).get();
      final cinemaName = cinemaDoc.exists && cinemaDoc.data() != null 
          ? cinemaDoc.data()!['name'] as String? ?? 'Unknown Cinema'
          : 'Unknown Cinema';

      return Ticket(
        id: bookingRef.id,
        movieName: movieData['title'] as String? ?? 'Unknown Movie',
        genre: movieData['genre'] as String? ?? 'Unknown Genre',
        date: '${date.day}/${date.month}/${date.year}',
        time: time,
        theater: cinemaName,
        seats: seats,
        cost: '${seats.length * seatPrice} ETB', 
        movieId: movieId, 
        cinemaId: cinemaId,
      );
    } catch (e) {
      print('Error booking tickets: $e');
      throw Exception('Failed to book tickets: ${e.toString()}');
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
          date: DateTime.parse(data['date']), // ✅ Parse ISO string back to DateTime
          time: data['time'],
          seats: List<String>.from(data['seats']),
          totalCost: data['totalCost']?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }
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
    // 1. Delete from user's bookings subcollection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .delete();

    // 2. Delete from global bookings collection
    final globalBookingQuery = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('movieId', isEqualTo: movieId)
        .where('cinemaId', isEqualTo: cinemaId)
        .where('date', isEqualTo: date.toIso8601String())
        .where('time', isEqualTo: time)
        .limit(1)
        .get();

    if (globalBookingQuery.docs.isNotEmpty) {
      await _firestore
          .collection('bookings')
          .doc(globalBookingQuery.docs.first.id)
          .delete();
    }

    // 3. Remove seats from showtime's bookedSeats
    final movieRef = _firestore
        .collection('cinemas')
        .doc(cinemaId)
        .collection('movies')
        .doc(movieId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(movieRef);
      
      if (!snapshot.exists) {
        throw Exception('Movie document not found');
      }
      
      final data = snapshot.data();
      if (data == null || !data.containsKey('showTimes')) {
        throw Exception('ShowTimes not found for movie');
      }

      final showTimes = List<dynamic>.from(data['showTimes'] as List);

      // Update the specific showtime
      final updatedShowTimes = showTimes.map((st) {
        try {
          final showTime = Map<String, dynamic>.from(st as Map<String, dynamic>);
          final showTimeDate = showTime['date'] as String?;
          final showTimeTime = showTime['time'] as String?;
          
          final targetDateString = date.toIso8601String().split('T')[0];
          
          if (showTimeDate == targetDateString && showTimeTime == time) {
            final bookedSeats = List<String>.from(showTime['bookedSeats'] as List? ?? []);
            // Remove all cancelled seats
            final updatedBookedSeats = bookedSeats.where((seat) => !seats.contains(seat)).toList();
            return {
              ...showTime,
              'bookedSeats': updatedBookedSeats,
            };
          }
          return showTime;
        } catch (e) {
          print('Error processing showtime: $e');
          return st;
        }
      }).toList();

      transaction.update(movieRef, {'showTimes': updatedShowTimes});
    });
  } catch (e) {
    print('Error cancelling ticket: $e');
    throw Exception('Failed to cancel ticket: ${e.toString()}');
  }
}
}