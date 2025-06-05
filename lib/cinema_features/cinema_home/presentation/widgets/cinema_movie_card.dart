import 'package:flutter/material.dart';
import '../../../../features/home/data/models/movie_model.dart';

class CinemaMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const CinemaMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  // @override
  // Widget build(BuildContext context) {
  // final Movie movie;
  // final VoidCallback onTap;

  // const MovieCard({
  //   super.key,
  //   required this.movie,
  //   required this.onTap,
  // });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                movie.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF121212), // Dark background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white, // White text
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
