// movie_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Movie>> getMovies({String? cinemaId}) async {
    try {
      // Get all cinemas first
      final cinemas = await getAllCinemas();
      
      // Get movies - either all or filtered by cinema
      final movies = <Movie>[];
      
      if (cinemaId != null) {
        // Get movies only for the specified cinema
        final moviesQuery = await _firestore
            .collection('cinemas')
            .doc(cinemaId)
            .collection('movies')
            .where('isActive', isEqualTo: true)
            .get();

        final cinema = cinemas.firstWhere((c) => c.id == cinemaId);
        for (var movieDoc in moviesQuery.docs) {
          movies.add(Movie.fromFirestore(movieDoc, [cinema]));
        }
      } else {
        // Get all movies from all cinemas
        final cinemaQuery = await _firestore.collection('cinemas').get();
        
        for (var cinemaDoc in cinemaQuery.docs) {
          final moviesQuery = await _firestore
              .collection('cinemas')
              .doc(cinemaDoc.id)
              .collection('movies')
              .where('isActive', isEqualTo: true)
              .get();

          final cinema = cinemas.firstWhere((c) => c.id == cinemaDoc.id);
          for (var movieDoc in moviesQuery.docs) {
            movies.add(Movie.fromFirestore(movieDoc, [cinema]));
          }
        }

        // Remove duplicates (movies with same title)
        final uniqueMovies = <String, Movie>{};
        for (var movie in movies) {
          if (!uniqueMovies.containsKey(movie.title)) {
            uniqueMovies[movie.title] = movie;
          } else {
            // Merge cinemas if movie exists in multiple cinemas
            uniqueMovies[movie.title]!.cinemas.addAll(movie.cinemas);
          }
        }
        return uniqueMovies.values.toList();
      }

      return movies;
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  Future<List<Cinema>> getAllCinemas() async {
    try {
      final cinemaQuery = await _firestore.collection('cinemas').get();
      return cinemaQuery.docs
          .map((doc) => Cinema.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching cinemas: $e');
      return [];
    }
  }

  Future<List<Cinema>> getCinemasForMovie(String movieTitle) async {
    try {
      final cinemaQuery = await _firestore.collection('cinemas').get();
      final cinemasWithMovie = <Cinema>[];

      for (var cinemaDoc in cinemaQuery.docs) {
        // Removed isActive filter here too
        final movieQuery = await _firestore
            .collection('cinemas')
            .doc(cinemaDoc.id)
            .collection('movies')
            .where('title', isEqualTo: movieTitle)
            .get(); // Removed .where('isActive', isEqualTo: true)

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