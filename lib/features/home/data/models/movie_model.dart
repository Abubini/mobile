class Movie {
  final String id;
  final String title;
  final String year;
  final String genre;
  final String length;
  final String description;
  final String imageUrl;
  final String trailerUrl;
  final List<Actor> cast;
  final List<Cinema> cinemas;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.length,
    required this.description,
    required this.imageUrl,
    required this.trailerUrl,
    required this.cast,
    required this.cinemas,
    
  });
}

class Actor {
  final String id;
  final String name;
  final String role;
  final String imageUrl;

  Actor({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class Cinema {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  

  Cinema({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    
  });
}