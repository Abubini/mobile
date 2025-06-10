// movie_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Movie>> getMovies() async {
    try {
      // First get all cinemas
      final cinemaQuery = await _firestore.collection('cinemas').get();
      final cinemas = cinemaQuery.docs
          .map((doc) => Cinema.fromFirestore(doc))
          .toList();

      // Then get all movies from all cinemas
      final movies = <Movie>[];
      
      for (var cinemaDoc in cinemaQuery.docs) {
        final moviesQuery = await _firestore
            .collection('cinemas')
            .doc(cinemaDoc.id)
            .collection('movies')
            .where('isActive', isEqualTo: true)
            .get();

        for (var movieDoc in moviesQuery.docs) {
          // Find cinemas that have this movie (by title)
          final movieCinemas = cinemas.where((cinema) {
            return moviesQuery.docs.any((m) => 
                m.data()['title'] == movieDoc.data()['title']);
          }).toList();

          movies.add(Movie.fromFirestore(movieDoc, movieCinemas));
        }
      }

      // Remove duplicates (movies with same title)
      final uniqueMovies = <String, Movie>{};
      for (var movie in movies) {
        if (!uniqueMovies.containsKey(movie.title)) {
          uniqueMovies[movie.title] = movie;
        }
      }

      return uniqueMovies.values.toList();
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }
}