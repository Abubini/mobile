// movie_detail_screen.dart
import 'package:cinema_app/features/home/data/repositories/movie_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../home/data/models/movie_model.dart';
import '../widgets/cast_item.dart';
import '../widgets/cinema_card.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late YoutubePlayerController _youtubeController;
  bool _showVideo = false;
  List<Cinema> _cinemas = [];
  bool _isLoadingCinemas = false;
  final MovieRepository _movieRepository = MovieRepository();

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.movie.trailerUrl) ?? '';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _loadCinemas();
  }
  Future<void> _loadCinemas() async {
    setState(() {
      _isLoadingCinemas = true;
    });
    
    try {
      final cinemas = await _movieRepository.getCinemasForMovie(widget.movie.title);
      setState(() {
        _cinemas = cinemas;
      });
    } catch (e) {
      print('Error loading cinemas: $e');
    } finally {
      setState(() {
        _isLoadingCinemas = false;
      });
    }
  }

  void _toggleVideo() {
    setState(() {
      _showVideo = !_showVideo;
      if (!_showVideo) {
        _youtubeController.pause();
      }
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showVideo) {
          setState(() {
            _showVideo = false;
          });
          return false;
        }
        context.go('/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: Text(widget.movie.title),
          backgroundColor: const Color(0xFF121212),
          foregroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_showVideo) {
                setState(() {
                  _showVideo = false;
                });
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Video/Image section
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video or Image display
                    _showVideo
                        ? YoutubePlayer(
                            controller: _youtubeController,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.green,
                          )
                        : Image.network(
                            widget.movie.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),

                    // Play/Pause button overlay
                    if (!_showVideo)
                      Positioned.fill(
                        child: Center(
                          child: IconButton(
                            iconSize: 60,
                            icon: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: _toggleVideo,
                          ),
                        ),
                      ),

                    // Close video button when video is playing
                    if (_showVideo)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          onPressed: _toggleVideo,
                        ),
                      ),
                  ],
                ),
              ),

              // Rest of the content remains the same...
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          widget.movie.year,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        const Text('|', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          widget.movie.genre,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        const Text('|', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          widget.movie.length,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.movie.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.movie.cast.length,
                        itemBuilder: (context, index) {
                          return CastItem(actor: widget.movie.cast[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cinemas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isLoadingCinemas
                        ? const Center(child: CircularProgressIndicator())
                        : _cinemas.isEmpty
                            ? const Text(
                                'No cinemas available for this movie',
                                style: TextStyle(color: Colors.grey),
                              )
                            :ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _cinemas.length,
                              itemBuilder: (context, index) {
                                return CinemaCard(
                                  cinema: _cinemas[index],
                                  onTap: () => context.go('/booking', extra: {
                                    'movie': widget.movie,
                                    'cinema': widget.movie.cinemas[index],
                                  }),
                                );
                              },
                            ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => context.go('/booking', extra: {
              'movie': widget.movie,
              'cinema': widget.movie.cinemas.first,
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('BOOK TICKET'),
          ),
        ),
      ),
    );
  }
}