// movie_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String genre;
  final String length;
  final String description;
  final double cost;
  final String trailerUrl;
  final String posterUrl;
  final List<Actor> cast;
  final List<Cinema> cinemas;
  final bool isActive;
  final DateTime? createdAt;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.length,
    required this.description,
    required this.cost,
    required this.trailerUrl,
    required this.posterUrl,
    required this.cast,
    required this.cinemas,
    required this.isActive,
    this.createdAt,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc, List<Cinema> cinemas) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id,
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      length: data['length'] ?? '',
      description: data['description'] ?? '',
      cost: data['cost']?.toDouble() ?? 0.0,
      trailerUrl: data['trailerUrl'] ?? '',
      posterUrl: data['posterUrl'] ?? '',
      cast: List<Map<String, dynamic>>.from(data['casts'] ?? [])
          .map((castData) => Actor.fromMap(castData))
          .toList(),
      cinemas: cinemas,
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt']?.toDate(),
    );
  }

  String get year => createdAt?.year.toString() ?? '2023';
  String get imageUrl => posterUrl;
}

class Actor {
  final String id;
  final String name;
  final String role;
  final String imageUrl;

  Actor({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

// movie_model.dart
class Cinema {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String phoneNumber;

  Cinema({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.phoneNumber,
  });

  factory Cinema.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cinema(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }
}