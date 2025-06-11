// home_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repo.dart';

class HomeProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  bool _isLoading = false;
  String? _error;
  String? _searchQuery;

  List<Movie> get movies => _searchQuery == null ? _movies : _filteredMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final MovieRepository _movieRepository = MovieRepository();

  Future<void> fetchMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _movies = await _movieRepository.getMovies();
      _filteredMovies = _movies;
    } catch (e) {
      _error = 'Failed to load movies';
      print('Error fetching movies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchMovies(String query) {
    _searchQuery = query.isEmpty ? null : query;
    
    if (_searchQuery == null) {
      _filteredMovies = _movies;
    } else {
      _filteredMovies = _movies.where((movie) => 
        movie.title.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    
    notifyListeners();
  }
}