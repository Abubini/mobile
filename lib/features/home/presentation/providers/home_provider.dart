import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repo.dart';

class HomeProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  final MovieRepository _movieRepository = MovieRepository();

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _movies = await _movieRepository.getMovies();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}