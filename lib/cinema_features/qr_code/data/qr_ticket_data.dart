class QRTicketData {
  final String movieName;
  final String genre;
  final String date;
  final String time;
  final String theater;
  final List<String> seats;
  final String cost;
  final String id;
  final String status;
  final String scannedAt;
  final String? cinemaId;

  QRTicketData({
    required this.movieName,
    required this.genre,
    required this.date,
    required this.time,
    required this.theater,
    required this.seats,
    required this.cost,
    required this.id,
    required this.status,
    required this.scannedAt,
    this.cinemaId,
  });

  factory QRTicketData.fromRawData(String rawData) {
    try {
      final lines = rawData.split('\n');
      final data = <String, String>{};
      
      for (final line in lines) {
        if (line.contains(':')) {
          final parts = line.split(':');
          if (parts.length >= 2) {
            data[parts[0].trim()] = parts.sublist(1).join(':').trim();
          }
        }
      }

      return QRTicketData(
        movieName: data['🎬 Movie'] ?? 'Unknown',
        genre: data['🎭 Genre'] ?? 'Unknown',
        date: data['📅 Date'] ?? 'Unknown',
        time: data['🕒 Time'] ?? 'Unknown',
        theater: data['📍 Theater'] ?? 'Unknown',
        seats: data['💺 Seats']?.split(', ') ?? [],
        cost: data['💰 Total'] ?? 'Unknown',
        id: data['ID'] ?? 'Unknown',
        status: data['Status'] ?? 'Unknown',
        scannedAt: data['Scanned'] ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      return QRTicketData(
        movieName: 'Invalid',
        genre: 'Ticket',
        date: 'Data',
        time: 'Format',
        theater: 'Unknown',
        seats: [],
        cost: 'Unknown',
        id: 'Unknown',
        status: 'Invalid QR Code',
        scannedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  DateTime? get parsedDate {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  DateTime? get parsedTime {
    try {
      final timeParts = time.split(':');
      if (timeParts.length == 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final date = parsedDate;
        if (date != null) {
          return DateTime(date.year, date.month, date.day, hour, minute);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool get isValid {
    if (status.toLowerCase().contains('invalid')) return false;
    if (status.toLowerCase().contains('expired')) return false;
    return true;
  }
}