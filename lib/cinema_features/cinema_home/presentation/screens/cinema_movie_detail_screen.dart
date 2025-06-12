import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CinemaMovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const CinemaMovieDetailScreen({super.key, required this.movie});

  @override
  State<CinemaMovieDetailScreen> createState() => _CinemaMovieDetailScreenState();
}

class _CinemaMovieDetailScreenState extends State<CinemaMovieDetailScreen> {
  late YoutubePlayerController _youtubeController;
  bool _showVideo = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
    _selectedDay = _getFirstShowDate();
  }

  void _initializeYoutubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.movie['trailerUrl'] ?? '') ?? '';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
      ),
    );
  }

  DateTime? _getFirstShowDate() {
    final showTimes = widget.movie['showTimes'] as List<dynamic>? ?? [];
    if (showTimes.isEmpty) return null;
    
    showTimes.sort((a, b) => (a['timestamp'] as Timestamp).compareTo(b['timestamp'] as Timestamp));
    return (showTimes.first['timestamp'] as Timestamp).toDate();
  }

  List<DateTime> _getShowDates() {
    final showTimes = widget.movie['showTimes'] as List<dynamic>? ?? [];
    return showTimes.map((st) => (st['timestamp'] as Timestamp).toDate()).toList();
  }

  void _toggleVideo() {
    setState(() {
      _showVideo = !_showVideo;
      if (!_showVideo) {
        _youtubeController.pause();
      }
    });
  }

  String _formatShowTimes() {
    final showTimes = widget.movie['showTimes'] as List<dynamic>? ?? [];
    if (showTimes.isEmpty) return 'No showtimes scheduled';

    final recurringShows = showTimes.where((st) => st['isRecurring'] == true).toList();
    final oneTimeShows = showTimes.where((st) => st['isRecurring'] != true).toList();

    String result = '';

    if (recurringShows.isNotEmpty) {
      final dayGroups = <String, List<String>>{};
      for (var show in recurringShows) {
        final day = show['dayOfWeek'] ?? 'Day';
        final time = show['time'] ?? 'Time';
        dayGroups.putIfAbsent(day, () => []).add(time);
      }

      dayGroups.forEach((day, times) {
        result += 'Schedule: \nEvery $day at ${times[0]}\n';
      });
    }

    if (oneTimeShows.isNotEmpty) {
      result += '\nSchedule:\nDate and Time:\n';
      for (var show in oneTimeShows) {
        final date = DateFormat('MMM dd, yyyy').format((show['timestamp'] as Timestamp).toDate());
        result += '$date at ${show['time']}\n';
      }
    }

    return result.trim();
  }

  // Add these helper methods to your _CinemaMovieDetailScreenState class:

bool _hasShowOnDay(DateTime day) {
  final showTimes = widget.movie['showTimes'] as List<dynamic>? ?? [];
  
  for (var showTime in showTimes) {
    if (showTime['isRecurring'] == true) {
      // For recurring shows, check if the day matches the dayOfWeek
      final dayOfWeek = showTime['dayOfWeek']?.toString().toLowerCase() ?? '';
      final dayName = _getDayName(day.weekday).toLowerCase();
      if (dayOfWeek.contains(dayName)) {
        return true;
      }
    } else {
      // For one-time shows, check if the date matches
      final showDate = (showTime['timestamp'] as Timestamp).toDate();
      if (showDate.year == day.year &&
          showDate.month == day.month &&
          showDate.day == day.day) {
        return true;
      }
    }
  }
  return false;
}

String _getDayName(int weekday) {
  switch (weekday) {
    case 1: return 'Monday';
    case 2: return 'Tuesday';
    case 3: return 'Wednesday';
    case 4: return 'Thursday';
    case 5: return 'Friday';
    case 6: return 'Saturday';
    case 7: return 'Sunday';
    default: return '';
  }
}

// Update your existing _getTimesForSelectedDay method to handle recurring shows:
List<String> _getTimesForSelectedDay() {
  if (_selectedDay == null) return [];
  
  final showTimes = widget.movie['showTimes'] as List<dynamic>? ?? [];
  List<String> times = [];
  
  for (var showTime in showTimes) {
    if (showTime['isRecurring'] == true) {
      // For recurring shows, check if the selected day matches the dayOfWeek
      final dayOfWeek = showTime['dayOfWeek']?.toString().toLowerCase() ?? '';
      final dayName = _getDayName(_selectedDay!.weekday).toLowerCase();
      if (dayOfWeek.contains(dayName)) {
        times.add(showTime['time'] as String? ?? 'Time');
      }
    } else {
      // For one-time shows, check if the date matches
      final showDate = (showTime['timestamp'] as Timestamp).toDate();
      if (showDate.year == _selectedDay!.year &&
          showDate.month == _selectedDay!.month &&
          showDate.day == _selectedDay!.day) {
        times.add(showTime['time'] as String? ?? 'Time');
      }
    }
  }
  
  return times;
}
  

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showDates = _getShowDates();
    final timesForSelectedDay = _getTimesForSelectedDay();
    final hasShowDates = showDates.isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        if (_showVideo) {
          setState(() => _showVideo = false);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: Text(widget.movie['title'] ?? 'Movie Details'),
          backgroundColor: const Color(0xFF121212),
          foregroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_showVideo) {
                setState(() => _showVideo = false);
              } else {
                context.go('/cinema/home');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/cinema/edit-movie', extra: widget.movie),
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
                    _showVideo
                        ? YoutubePlayer(
                            controller: _youtubeController,
                            aspectRatio: 16/9,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.green,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.green,
                              handleColor: Colors.greenAccent,
                            ),
                            onReady: () {
                              _youtubeController.addListener(() {});
                            },
                          )
                        : Image.network(
                            widget.movie['posterUrl'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => 
                              Container(color: Colors.grey),
                          ),

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

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie['title'] ?? 'No Title',
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
                          widget.movie['length'] ?? 'N/A',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        const Text('|', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          widget.movie['genre'] ?? 'N/A',
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
                      widget.movie['description'] ?? 'No description available',
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
                        itemCount: (widget.movie['casts'] as List<dynamic>? ?? []).length,
                        itemBuilder: (context, index) {
                          final cast = widget.movie['casts'][index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(cast['imageUrl'] ?? ''),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cast['name'] ?? 'Cast',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // ... [Keep all your existing widgets for title, description, cast etc.]

                    // Show Schedule Section
                    const Text(
                      'Show Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatShowTimes(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    
                    // Calendar Section - Only show if we have show dates
                    if (hasShowDates) ...[
                      const Text(
                        'Calendar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: TableCalendar(
                          // Fix: Use a reasonable date range instead of trying to calculate from potentially empty show dates
                          firstDay: DateTime.now().subtract(const Duration(days: 30)),
                          lastDay: DateTime.now().add(const Duration(days: 365)),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            // Only allow selection of days that have shows
                            if (_hasShowOnDay(selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            }
                          },
                          onFormatChanged: (format) => setState(() => _calendarFormat = format),
                          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Month',
                            CalendarFormat.week: 'Week',
                          },
                          calendarStyle: CalendarStyle(
                            selectedDecoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            defaultTextStyle: const TextStyle(color: Colors.white),
                            weekendTextStyle: const TextStyle(color: Colors.white),
                            outsideDaysVisible: false,
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            formatButtonDecoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            formatButtonTextStyle: const TextStyle(color: Colors.green),
                            titleTextStyle: const TextStyle(color: Colors.white),
                            leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.green),
                            rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.green),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.white),
                            weekendStyle: TextStyle(color: Colors.white),
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              final hasShow = _hasShowOnDay(day);
                              return Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: hasShow ? Colors.green.withOpacity(0.3) : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: TextStyle(
                                      color: hasShow ? Colors.white : Colors.grey,
                                      fontWeight: hasShow ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Show times for selected day
                      if (_selectedDay != null && _getTimesForSelectedDay().isNotEmpty) ...[
                        Text(
                          'Time for ${DateFormat('MMM dd, yyyy').format(_selectedDay!)}:',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(
                            _getTimesForSelectedDay().first, // Only show the first time
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ],
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