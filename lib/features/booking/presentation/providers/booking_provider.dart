import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:flutter/material.dart';
// import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repo.dart';

class BookingProvider with ChangeNotifier {
  final BookingRepository _repository = BookingRepository();
  
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final Set<String> _selectedSeats = {};
  final Map<String, List<String>> _bookedSeats = {};

  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  Set<String> get selectedSeats => _selectedSeats;

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void toggleSeat(String seatId) {
    if (_selectedSeats.contains(seatId)) {
      _selectedSeats.remove(seatId);
    } else {
      _selectedSeats.add(seatId);
    }
    notifyListeners();
  }

  void resetSelection() {
    _selectedTime = null;
    _selectedSeats.clear();
    notifyListeners();
  }

  void clearSeats() {
    _selectedSeats.clear();
    notifyListeners();
  }
  void releaseSeats(DateTime date, String time, List<String> seats) {
    final key = "${date.year}-${date.month}-${date.day}-$time";
    if (_bookedSeats.containsKey(key)) {
      _bookedSeats[key] = _bookedSeats[key]!.where((seat) => !seats.contains(seat)).toList();
      if (_bookedSeats[key]!.isEmpty) {
        _bookedSeats.remove(key);
      }
      notifyListeners();
    }
  }

  List<String> getTakenSeats() {
    if (_selectedTime == null) return [];
    final key = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}-$_selectedTime";
    return _bookedSeats[key] ?? [];
  }

  Future<Ticket> bookTickets() async {
    if (_selectedTime == null || _selectedSeats.isEmpty) {
      throw Exception('No seats or time selected');
    }
    
    final key = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}-$_selectedTime";
    _bookedSeats[key] = [...(_bookedSeats[key] ?? []), ..._selectedSeats];
    
    final ticket = await _repository.bookTickets(
      date: _selectedDate,
      time: _selectedTime!,
      seats: _selectedSeats.toList(),
    );
    
    resetSelection();
    return ticket;
  }
}
