import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../features/home/data/models/movie_model.dart';
import '../../../../features/movie_detail/presentation/widgets/cast_item.dart';

class CinemaMovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const CinemaMovieDetailScreen({super.key, required this.movie});

  @override
  State<CinemaMovieDetailScreen> createState() => _CinemaMovieDetailScreenState();
}

class _CinemaMovieDetailScreenState extends State<CinemaMovieDetailScreen> {
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
        context.go('/cinema/home');
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
                context.go('/cinema/home');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit movie screen
                context.go('/edit-movie', extra: widget.movie);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _showVideo && _isVideoInitialized
                        ? Chewie(controller: _chewieController!)
                        : Image.network(
                            widget.movie.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),

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
                    // No cinemas section for admin
                    // No book ticket button for admin
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}