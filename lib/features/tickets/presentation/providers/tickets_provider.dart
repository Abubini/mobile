import 'package:cinema_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/tickets_repo.dart';
import '../../data/models/ticket_model.dart';

class TicketsProvider with ChangeNotifier {
  final TicketsRepository _repository = TicketsRepository();
  final BookingProvider _bookingProvider;
  List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  TicketsProvider(this._bookingProvider) { // Update constructor
    loadTickets();
  }

  Future<void> loadTickets() async {
    _tickets = _repository.getTickets();
    notifyListeners();
  }

  Future<void> addTicket(Ticket ticket) async {
    _tickets.add(ticket);
    notifyListeners();
  }

   Future<void> deleteTicket(String ticketId) async {
    final ticket = _tickets.firstWhere((t) => t.id == ticketId);
    await _repository.deleteTicket(ticketId);
    _tickets.removeWhere((ticket) => ticket.id == ticketId);
    
    // Parse the date and time from the ticket
    final dateParts = ticket.date.split('-');
    final date = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );
    
    // Release the seats
    _bookingProvider.releaseSeats(date, ticket.time, ticket.seats);
    
    notifyListeners();
  }
}