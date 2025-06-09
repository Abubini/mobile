import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CinemaHomeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> loadMovies(String cinemaId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await FirebaseFirestore.instance
          .collection('cinemas')
          .doc(cinemaId)
          .collection('movies')
          .where('isActive', isEqualTo: true)
          .get();

      _movies = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}