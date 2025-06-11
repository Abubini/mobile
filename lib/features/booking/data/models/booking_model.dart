// booking_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowTime {
  final DateTime date;
  final String time;
  final List<String> bookedSeats;
  final double price;
  final bool isRecurring;
  final String? dayOfWeek;

  ShowTime({
    required this.date,
    required this.time,
    required this.bookedSeats,
    required this.price,
    this.isRecurring = false,
    this.dayOfWeek,
  });
}

class Booking {
  final String? id;  // Add this field
  final String movieId;
  final String cinemaId;
  final DateTime date;
  final String time;
  final List<String> seats;
  final double totalCost;
  final String? userId;

  Booking({
    this.id,  // Add this
    required this.movieId,
    required this.cinemaId,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalCost,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'cinemaId': cinemaId,
      'date': date.toIso8601String(), // Changed from Timestamp to ISO string
      'time': time,
      'seats': seats,
      'totalCost': totalCost,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Add this factory method
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      movieId: data['movieId'],
      cinemaId: data['cinemaId'],
      date: DateTime.parse(data['date']),
      time: data['time'],
      seats: List<String>.from(data['seats']),
      totalCost: data['totalCost']?.toDouble() ?? 0.0,
      userId: data['userId'],
    );
  }
}
class Cinema {
  final String id;
  final String name;
  final String location;
  final String imageUrl;

  Cinema({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
  });

  factory Cinema.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Cinema(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}