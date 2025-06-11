import 'package:cinema_app/features/home/presentation/providers/home_provider.dart';
import 'package:cinema_app/features/home/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/carousel_widget.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchExpanded = false;
  bool _isFilterExpanded = false;
  String? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedButton;

  final List<String> _filterOptions = [
    'Action',
    'Space',
    'Fantasy',
    'Romantic',
    'Dark',
    'Stage',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final movies = homeProvider.movies;

    if (homeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('BOOKMYSCREEN'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.green,
        toolbarHeight: 40,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
              homeProvider.searchMovies('');
            });
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const CarouselWidget(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCustomButton('Search', () {
                          if (_isSearchExpanded && _searchController.text.isNotEmpty) {
                            homeProvider.searchMovies(_searchController.text);
                          }
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
                            homeProvider.searchMovies('');
                          });
                        }, _selectedButton == 'Filter'),
                      ],
                    ),
                  ),

                  if (_isSearchExpanded) _buildSearchField(),

                  if (_isFilterExpanded) _buildFilterChips(),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: movies.isEmpty
                      ? const Center(
                          child: Text(
                            'No movies found',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return MovieCard(
                              movie: movies[index],
                              onTap: () => context.go('/movie-detail', extra: movies[index]),
                            );
                          },
                        ),
                  ),
                ],
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/tickets'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.confirmation_number),
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
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () {
              setState(() {
                _isSearchExpanded = false;
                _searchController.clear();
                _selectedButton = null;
              });
              Provider.of<HomeProvider>(context, listen: false).searchMovies('');
            },
          ),
        ),
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.green,
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