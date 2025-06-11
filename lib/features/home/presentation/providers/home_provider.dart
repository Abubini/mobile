// home_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repo.dart';

class HomeProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  List<Cinema> _cinemas = [];
  bool _isLoading = false;
  String? _error;
  String? _searchQuery;
  Cinema? _selectedCinema;

  List<Movie> get movies => _filteredMovies;
  List<Cinema> get cinemas => _cinemas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Cinema? get selectedCinema => _selectedCinema;

  final MovieRepository _movieRepository = MovieRepository();

  Future<void> fetchMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _cinemas = await _movieRepository.getAllCinemas();
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

  Future<void> filterByCinema(Cinema? cinema) async {
    _isLoading = true;
    _selectedCinema = cinema;
    notifyListeners();
    
    try {
      if (cinema == null) {
        _movies = await _movieRepository.getMovies();
      } else {
        _movies = await _movieRepository.getMovies(cinemaId: cinema.id);
      }
      _applyFilters();
    } catch (e) {
      _error = 'Failed to filter movies';
      print('Error filtering movies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchMovies(String query) {
    _searchQuery = query.isEmpty ? null : query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredMovies = _movies;
    
    // Apply search filter
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      _filteredMovies = _filteredMovies.where((movie) => 
        movie.title.toLowerCase().contains(_searchQuery!.toLowerCase())
      ).toList();
    }
    
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = null;
    filterByCinema(null);
  }
}