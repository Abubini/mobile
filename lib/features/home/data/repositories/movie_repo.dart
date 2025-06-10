// movie_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Movie>> getMovies() async {
    try {
      // Get all cinemas
      final cinemaQuery = await _firestore.collection('cinemas').get();
      final cinemas = cinemaQuery.docs
          .map((doc) => Cinema.fromFirestore(doc))
          .toList();

      // Get all movies from all cinemas
      final movies = <Movie>[];
      
      for (var cinemaDoc in cinemaQuery.docs) {
        final moviesQuery = await _firestore
            .collection('cinemas')
            .doc(cinemaDoc.id)
            .collection('movies')
            .where('isActive', isEqualTo: true)
            .get();

        for (var movieDoc in moviesQuery.docs) {
          movies.add(Movie.fromFirestore(movieDoc, [])); // Empty cinemas list for now
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

  Future<List<Cinema>> getCinemasForMovie(String movieTitle) async {
    try {
      final cinemaQuery = await _firestore.collection('cinemas').get();
      final cinemasWithMovie = <Cinema>[];

      for (var cinemaDoc in cinemaQuery.docs) {
        final movieQuery = await _firestore
            .collection('cinemas')
            .doc(cinemaDoc.id)
            .collection('movies')
            .where('title', isEqualTo: movieTitle)
            .where('isActive', isEqualTo: true)
            .get();

        if (movieQuery.docs.isNotEmpty) {
          final cinemaData = cinemaDoc.data() as Map<String, dynamic>;
          cinemasWithMovie.add(Cinema(
            id: cinemaDoc.id,
            name: cinemaData['name'] ?? '',
            location: cinemaData['location'] ?? '',
            imageUrl: cinemaData['imageUrl'] ?? '',
            phoneNumber: cinemaData['phoneNumber'] ?? '',
          ));
        }
      }

      return cinemasWithMovie;
    } catch (e) {
      print('Error fetching cinemas for movie: $e');
      return [];
    }
  }
}