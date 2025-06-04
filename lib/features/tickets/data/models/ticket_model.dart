class Ticket {
  final String id;
  final String movieName;
  final String genre;
  final String date;
  final String time;
  final String theater;
  final List<String> seats;
  final String cost;

  Ticket({
    required this.id,
    required this.movieName,
    required this.genre,
    required this.date,
    required this.time,
    required this.theater,
    required this.seats,
    required this.cost,
  });

  String get formattedDate {
    final dateTime = DateTime.parse(date);
    return '${_getWeekday(dateTime.weekday)}, ${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
  }

  String get formattedTime {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts[1];
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $ampm';
  }

  DateTime get dateTime {
  final timeParts = time.split(':');
  return DateTime(
    DateTime.parse(date).year,
    DateTime.parse(date).month,
    DateTime.parse(date).day,
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );
}

bool get isValid => dateTime.isAfter(DateTime.now());

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