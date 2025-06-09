import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMovie({
    required String cinemaId,
    required String title,
    required String genre,
    required String length,
    required String description,
    required double cost,
    required String trailerUrl,
    required String posterUrl,
    required List<Map<String, String>> casts,
    required List<Map<String, dynamic>> showTimes,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.uid != cinemaId) {
        throw Exception('Not authorized to upload for this cinema');
      }

      await _firestore.collection('cinemas').doc(cinemaId).collection('movies').add({
        'title': title,
        'genre': genre,
        'length': length,
        'description': description,
        'cost': cost,
        'trailerUrl': trailerUrl,
        'posterUrl': posterUrl,
        'casts': casts,
        'showTimes': showTimes,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
      
      print('Movie added successfully to Firestore');
    } catch (e) {
      print('Error adding movie: $e');
      throw Exception('Failed to add movie: $e');
    }
  }
}