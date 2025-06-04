import '../models/movie_model.dart';

class MovieRepository {
  Future<List<Movie>> getMovies() async {
    // Implement actual API call to fetch movies
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      Movie(
        id: '1',
        title: 'Prey 2019',
        year: '2019',
        genre: 'Horror',
        length: '1:30:25',
        description: 'A gripping horror film about a group of friends who encounter a terrifying presence in the woods while on a camping trip.',
        imageUrl: 'https://storage.googleapis.com/a1aa/image/ad63c698-81fa-4c6e-906e-ce5a6f8d7922.jpg',
        trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        cast: [
          Actor(
            id: '1',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '2',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '3',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '4',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '5',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          // Add more cast members
        ],
        cinemas: [
          Cinema(
            id: '1',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '2',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '3',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '4',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          // Add more cinemas
        ],
      ),
      Movie(
        id: '2',
        title: 'Prey 2019',
        year: '2019',
        genre: 'Horror',
        length: '1:30:25',
        description: 'A gripping horror film about a group of friends who encounter a terrifying presence in the woods while on a camping trip.',
        imageUrl: 'https://storage.googleapis.com/a1aa/image/ad63c698-81fa-4c6e-906e-ce5a6f8d7922.jpg',
        trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        cast: [
          Actor(
            id: '1',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '2',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '3',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '4',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '5',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          // Add more cast members
        ],
        cinemas: [
          Cinema(
            id: '1',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '2',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
          ),
          Cinema(
            id: '3',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
          ),
          Cinema(
            id: '4',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
          ),
          // Add more cinemas
        ],
      ),
      Movie(
        id: '3',
        title: 'Prey 2019',
        year: '2019',
        genre: 'Horror',
        length: '1:30:25',
        description: 'A gripping horror film about a group of friends who encounter a terrifying presence in the woods while on a camping trip.',
        imageUrl: 'https://storage.googleapis.com/a1aa/image/ad63c698-81fa-4c6e-906e-ce5a6f8d7922.jpg',
        trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        cast: [
          Actor(
            id: '1',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '2',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '3',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '4',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '5',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          // Add more cast members
        ],
        cinemas: [
          Cinema(
            id: '1',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '2',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '3',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '4',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          // Add more cinemas
        ],
      ),
      Movie(
        id: '4',
        title: 'Prey 2019',
        year: '2019',
        genre: 'Horror',
        length: '1:30:25',
        description: 'A gripping horror film about a group of friends who encounter a terrifying presence in the woods while on a camping trip.',
        imageUrl: 'https://storage.googleapis.com/a1aa/image/ad63c698-81fa-4c6e-906e-ce5a6f8d7922.jpg',
        trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        cast: [
          Actor(
            id: '1',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '2',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '3',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '4',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '5',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          // Add more cast members
        ],
        cinemas: [
          Cinema(
            id: '1',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '2',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '3',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '4',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          // Add more cinemas
        ],
      ),
      Movie(
        id: '5',
        title: 'Prey 2019',
        year: '2019',
        genre: 'Horror',
        length: '1:30:25',
        description: 'A gripping horror film about a group of friends who encounter a terrifying presence in the woods while on a camping trip.',
        imageUrl: 'https://storage.googleapis.com/a1aa/image/ad63c698-81fa-4c6e-906e-ce5a6f8d7922.jpg',
        trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        cast: [
          Actor(
            id: '1',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '2',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '3',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '4',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '5',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          // Add more cast members
        ],
        cinemas: [
          Cinema(
            id: '1',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '2',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '3',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '4',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          // Add more cinemas
        ],
      ),
      Movie(
        id: '6',
        title: 'estifanos',
        year: '2019',
        genre: 'Horror',
        length: '1:30:25',
        description: 'A gripping horror film about a group of friends who encounter a terrifying presence in the woods while on a camping trip.',
        imageUrl: 'https://storage.googleapis.com/a1aa/image/ad63c698-81fa-4c6e-906e-ce5a6f8d7922.jpg',
        trailerUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        cast: [
          Actor(
            id: '1',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '2',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '3',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '4',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          Actor(
            id: '5',
            name: 'Lucas Reed',
            role: 'Actor',
            imageUrl: 'https://storage.googleapis.com/a1aa/image/9fbfb76d-bb35-4918-d1ec-c4869fab9742.jpg',
          ),
          // Add more cast members
        ],
        cinemas: [
          Cinema(
            id: '1',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '2',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '3',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          Cinema(
            id: '4',
            name: 'Grandview Cinema',
            location: '123 Main St',
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            
          ),
          // Add more cinemas
        ],
      ),
      // Add more movies
    ];
  }
}