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
  bool _isFilterExpanded = false;
  String? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedButton;

  final List<String> _filterOptions = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
  ];

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
              _selectedButton = null;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCustomButton('Search', () {
                        setState(() {
                          _isSearchExpanded = true;
                          _isFilterExpanded = false;
                          _selectedFilter = null;
                          _selectedButton = 'Search';
                        });
                      }, _selectedButton == 'Search'),
                      _buildCustomButton('Filter', () {
                        setState(() {
                          _isFilterExpanded = true;
                          _isSearchExpanded = false;
                          _searchController.clear();
                          _selectedButton = 'Filter';
                        });
                      }, _selectedButton == 'Filter'),
                    ],
                  ),
                ),

                if (_isSearchExpanded) _buildSearchField(),
                if (_isFilterExpanded) _buildFilterChips(),

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

            if (_isFilterExpanded)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFilterExpanded = false;
                    _selectedFilter = null;
                  });
                },
                behavior: HitTestBehavior.opaque,
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

  Widget _buildCustomButton(String label, VoidCallback onPressed, bool isSelected) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.green, 
        backgroundColor: isSelected ? Colors.green : const Color(0xFF2d2d2d),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearchExpanded = false;
                _searchController.clear();
                _selectedButton = null;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _filterOptions.map((filter) {
          return ChoiceChip(
            label: Text(filter),
            selected: _selectedFilter == filter,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = selected ? filter : null;
              });
            },
            selectedColor: Colors.green,
            labelStyle: TextStyle(
              color: _selectedFilter == filter ? Colors.white : Colors.white70,
            ),
            backgroundColor: const Color(0xFF2d2d2d),
          );
        }).toList(),
      ),
    );
  }
}