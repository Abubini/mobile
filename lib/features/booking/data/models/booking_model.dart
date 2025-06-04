class Booking {
  final DateTime date;
  final String time;
  final List<String> seats;

  Booking({
    required this.date,
    required this.time,
    required this.seats,
  });

  String get dateKey => "${date.year}-${date.month}-${date.day}";
  String get uniqueKey => "$dateKey-$time";
}