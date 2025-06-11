class Ticket {
  final String id;
  final String movieName;
  final String movieId; // Add this
  final String cinemaId; // Add this
  final String genre;
  final String date;
  final String time;
  final String theater;
  final List<String> seats;
  final String cost;

  Ticket({
    required this.id,
    required this.movieName,
    required this.movieId,
    required this.cinemaId,
    required this.genre,
    required this.date,
    required this.time,
    required this.theater,
    required this.seats,
    required this.cost,
  });

  String get formattedDate {
    try {
      final dateTime = DateTime.parse(date);
      return '${_getWeekday(dateTime.weekday)}, ${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return date; // Fallback to raw date if parsing fails
    }
  }

  String get formattedTime {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      final ampm = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;
      return '$hour12:$minute $ampm';
    } catch (e) {
      return time; // Fallback to raw time if parsing fails
    }
  }

  DateTime get dateTime {
  try {
    // Handle different possible date formats
    if (date.contains('/')) {
      // Handle "dd/MM/yyyy" format
      final dateParts = date.split('/');
      final timeParts = time.split(':');
      
      // Handle 12-hour format with AM/PM if present
      var hour = int.parse(timeParts[0]);
      var minute = int.parse(timeParts[1].split(' ')[0]);
      
      if (time.contains('PM') && hour != 12) {
        hour += 12;
      } else if (time.contains('AM') && hour == 12) {
        hour = 0;
      }
      
      return DateTime(
        int.parse(dateParts[2]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[0]), // day
        hour,
        minute,
      );
    } else {
      // Handle ISO string format
      final dateTimeObj = DateTime.parse(date);
      final timeParts = time.split(':');
      return DateTime(
        dateTimeObj.year,
        dateTimeObj.month,
        dateTimeObj.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    }
  } catch (e) {
    print('Error parsing dateTime: $e');
    return DateTime.now().add(const Duration(days: 1)); // Fallback to tomorrow
  }
}


  bool get isValid {
  final now = DateTime.now();
  final dt = dateTime;
  print("Now: $now, Ticket time: $dt");
  return dt.isAfter(now);
}


  String _getWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}