import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _showVideo = false;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.movie.trailerUrl);
    
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        placeholder: Container(color: Colors.black),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Failed to load video',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      setState(() {
        _isVideoInitialized = false;
      });
    }
  }

  void _toggleVideo() {
    setState(() {
      _showVideo = !_showVideo;
      if (_showVideo && _chewieController != null) {
        _chewieController!.play();
      } else if (_chewieController != null) {
        _chewieController!.pause();
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
              // Video/Image section that scrolls normally
              SizedBox(
                height: 250, // Fixed height that won't change when scrolling
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video or Image display
                    _showVideo && _isVideoInitialized
                        ? Chewie(controller: _chewieController!)
                        : Image.network(
                            widget.movie.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),

                    // Play/Pause button overlay
                    if (!_showVideo || !_isVideoInitialized)
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
                            onPressed: _isVideoInitialized ? _toggleVideo : null,
                          ),
                        ),
                      ),

                    // Close video button when video is playing
                    if (_showVideo && _isVideoInitialized)
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

              // Content below
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.movie.cinemas.length,
                      itemBuilder: (context, index) {
                        return CinemaCard(
                          cinema: widget.movie.cinemas[index],
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