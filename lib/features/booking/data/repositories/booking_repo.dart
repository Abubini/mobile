// import '../models/booking_model.dart';
import '../../../tickets/data/models/ticket_model.dart';

class BookingRepository {
  Future<Ticket> bookTickets({
    required DateTime date,
    required String time,
    required List<String> seats,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    return Ticket(
      id: 'TK${DateTime.now().millisecondsSinceEpoch}',
      movieName: 'Avengers: Endgame',
      genre: 'Action',
      date: date.toIso8601String().split('T')[0],
      time: time,
      theater: 'Screen ${seats.length % 3 + 1}',
      seats: seats,
      cost: '${seats.length * 10} ETB',
    );
  }
}