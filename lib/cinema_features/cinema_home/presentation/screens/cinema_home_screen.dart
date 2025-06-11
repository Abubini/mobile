import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cinema_home_provider.dart';
import '../widgets/cinema_movie_card.dart';
import 'cinema_settings_screen.dart';

class CinemaHomeScreen extends StatefulWidget {
  const CinemaHomeScreen({super.key});

  @override
  State<CinemaHomeScreen> createState() => _CinemaHomeScreenState();
}

class _CinemaHomeScreenState extends State<CinemaHomeScreen> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Provider.of<CinemaHomeProvider>(context, listen: false)
            .loadMovies(user.uid);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cinemaProvider = Provider.of<CinemaHomeProvider>(context);
    final movies = cinemaProvider.movies;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('POSTED MOVIES'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.green,
        toolbarHeight: 40,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CinemaSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      
      body: GestureDetector(
        onTap: () {
          if (_isSearchExpanded) {
            setState(() {
              _isSearchExpanded = false;
              _searchController.clear();
              cinemaProvider.searchMovies('');
            });
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildSearchButton(),
                      if (_isSearchExpanded) 
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildSearchField(),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: cinemaProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : movies.isEmpty
                          ? const Center(
                              child: Text(
                                'No movies available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: movies.length,
                                itemBuilder: (context, index) {
                                  return CinemaMovieCard(
                                    movie: movies[index],
                                    onTap: () => context.go(
                                      '/cinema/movie-detail',
                                      extra: movies[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.push('/cinema/add-movie'),
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
            heroTag: 'addButton',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => context.push('/cinema/scan'),
            backgroundColor: Colors.green,
            child: const Icon(Icons.camera_alt),
            heroTag: 'cameraButton',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: () {
        if (_isSearchExpanded && _searchController.text.isNotEmpty) {
          Provider.of<CinemaHomeProvider>(context, listen: false)
              .searchMovies(_searchController.text);
        }
        setState(() {
          _isSearchExpanded = !_isSearchExpanded;
          if (!_isSearchExpanded) {
            _searchController.clear();
            Provider.of<CinemaHomeProvider>(context, listen: false)
                .searchMovies('');
          }
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _isSearchExpanded ? Colors.white : Colors.green,
        backgroundColor: _isSearchExpanded ? Colors.green : const Color(0xFF2d2d2d),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Search'),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFF2d2d2d),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.green),
          onPressed: () {
            Provider.of<CinemaHomeProvider>(context, listen: false)
                .searchMovies(_searchController.text);
          },
        ),
      ),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.green,
      onSubmitted: (value) {
        Provider.of<CinemaHomeProvider>(context, listen: false)
            .searchMovies(value);
      },
    );
  }
}