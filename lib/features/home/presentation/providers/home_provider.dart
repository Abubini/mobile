// home_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repo.dart';

class HomeProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _error;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final MovieRepository _movieRepository = MovieRepository();

  Future<void> fetchMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _movies = await _movieRepository.getMovies();
    } catch (e) {
      _error = 'Failed to load movies';
      print('Error fetching movies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}