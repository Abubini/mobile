// booking_provider.dart
import 'package:cinema_app/features/booking/data/models/booking_model.dart';
import 'package:cinema_app/features/booking/data/repositories/booking_repo.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import '../models/booking_model.dart';
// import '../../tickets/data/models/ticket_model.dart';
// import '../repositories/booking_repo.dart';

class BookingProvider with ChangeNotifier {
  final BookingRepository _repository = BookingRepository();
  
  DateTime? _selectedDate;
  String? _selectedTime;
  final Set<String> _selectedSeats = {};
  List<ShowTime> _showTimes = [];
  double _seatPrice = 0.0;
  String? _movieId;
  String? _cinemaId;
  String? _movieTitle;
  String? _cinemaName;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  Set<String> get selectedSeats => _selectedSeats;
  double get seatPrice => _seatPrice;
  String? get movieTitle => _movieTitle;
  String? get cinemaName => _cinemaName;

  Future<void> initializeBooking(
  String movieId,
  String cinemaId,
  String movieTitle,
  String cinemaName,
  double seatPrice,
) async {
  _movieId = movieId;
  _cinemaId = cinemaId;
  _movieTitle = movieTitle;
  _cinemaName = cinemaName;
  _seatPrice = seatPrice;
  
  try {
    _showTimes = await _repository.getShowTimes(movieId, cinemaId);
    
    if (_showTimes.isNotEmpty) {
      // Sort showtimes by date and time
      _showTimes.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });
      
      _selectedDate = _showTimes.first.date;
      _selectedTime = _showTimes.first.time;
    } else {
      _selectedDate = null;
      _selectedTime = null;
    }
  } catch (e) {
    _showTimes = [];
    _selectedDate = null;
    _selectedTime = null;
    rethrow;
  } finally {
    notifyListeners();
  }
}

  List<DateTime> getAvailableDates() {
  // Ensure we're using the same filtering logic as in getShowTimes()
  final now = DateTime.now();
  return _showTimes
      .where((st) => st.date.isAfter(now))
      .map((st) => st.date)
      .toSet() // Remove duplicates
      .toList()
      ..sort(); // Sort chronologically
}
  

  List<String> getAvailableTimes() {
    if (_selectedDate == null) return [];
    return _showTimes
        .where((st) => DateUtils.isSameDay(st.date, _selectedDate!))
        .map((st) => st.time)
        .toList();
  }

  List<String> getTakenSeats() {
    if (_selectedDate == null || _selectedTime == null) return [];
    final showTime = _showTimes.firstWhere(
      (st) => 
        DateUtils.isSameDay(st.date, _selectedDate!) && 
        st.time == _selectedTime,
      orElse: () => ShowTime(date: DateTime.now(), time: '', bookedSeats: [], price: 0),
    );
    return showTime.bookedSeats;
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null;
    _selectedSeats.clear();
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    _selectedSeats.clear();
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

  Future<Ticket> bookTickets() async {
    if (_movieId == null || 
        _cinemaId == null || 
        _selectedDate == null || 
        _selectedTime == null || 
        _selectedSeats.isEmpty) {
      throw Exception('Missing required booking information');
    }
    
    return await _repository.bookTickets(
      movieId: _movieId!,
      cinemaId: _cinemaId!,
      date: _selectedDate!,
      time: _selectedTime!,
      seats: _selectedSeats.toList(),
      seatPrice: _seatPrice,
    );
  }
}