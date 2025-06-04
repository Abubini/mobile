import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _pageController = PageController();
  // ignore: unused_field
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'image': 'https://storage.googleapis.com/a1aa/image/f1104928-6741-4cd1-ca97-94ebf2f623c7.jpg',
      'title': 'Blue Beetle',
      'subtitle': 'THE DC UNIVERSE',
    },
    {
      'image': 'https://storage.googleapis.com/a1aa/image/ab884594-b4e6-4834-1e55-e2162df49a06.jpg',
      'title': 'Superman',
      'subtitle': 'THE DC UNIVERSE',
    },
    {
      'image': 'https://storage.googleapis.com/a1aa/image/dd3ce039-dc35-4fff-c14a-45aec4789f5f.jpg',
      'title': 'Wonder Woman',
      'subtitle': 'THE DC UNIVERSE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.network(
                    _slides[index]['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF1e1e1e).withOpacity(0.8),
                          Colors.transparent,
                          const Color(0xFF1e1e1e).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _slides[index]['subtitle'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _slides[index]['title'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.play_circle_fill, size: 48),
                      color: Colors.white.withOpacity(0.8),
                      onPressed: () {
                        // Play trailer
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _slides.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.green,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}