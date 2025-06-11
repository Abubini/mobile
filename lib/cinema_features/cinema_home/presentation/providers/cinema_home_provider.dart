import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CinemaHomeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _movies = [];
  List<Map<String, dynamic>> _filteredMovies = [];
  bool _isLoading = false;
  String? _searchQuery;

  List<Map<String, dynamic>> get movies => _searchQuery == null ? _movies : _filteredMovies;
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

      _filteredMovies = _movies;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void searchMovies(String query) {
    _searchQuery = query.isEmpty ? null : query;
    
    if (_searchQuery == null) {
      _filteredMovies = _movies;
    } else {
      _filteredMovies = _movies.where((movie) => 
        movie['title'].toLowerCase().contains(_searchQuery!.toLowerCase())
      ).toList();
    }
    
    notifyListeners();
  }
}