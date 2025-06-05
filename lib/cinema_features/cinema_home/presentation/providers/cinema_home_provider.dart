import 'package:cinema_app/features/home/data/models/movie_model.dart';
import 'package:cinema_app/features/home/data/repositories/movie_repo.dart';
import 'package:flutter/foundation.dart';


class CinemaHomeProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  final MovieRepository _movieRepository = MovieRepository();

  Future<void> loadMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _movies = await _movieRepository.getMovies();
    } catch (e) {
      // Handle error
      debugPrint('Error loading movies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}