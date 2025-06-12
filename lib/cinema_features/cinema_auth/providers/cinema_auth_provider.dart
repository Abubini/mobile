import 'package:cinema_app/cinema_features/cinema_auth/repositories/cinema_auth_repo.dart';
import 'package:cinema_app/cinema_features/cinema_auth/repositories/cinema_auth_repo.dart' as _authRepository;
import 'package:flutter/material.dart';

class CinemaAuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  final CinemaAuthRepository _authRepository = CinemaAuthRepository();

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String phoneOrEmail, String password) async {
    try {
      await _authRepository.login(phoneOrEmail, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      rethrow; // This will propagate the error to the UI
    }
  }

  Future<void> signup(String name, String phone, String password, String location) async {
    try {
      await _authRepository.signup(name, phone, password, location);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      // _isAuthenticated = false;
      notifyListeners();
      rethrow; // This will propagate the error to the UI
    }
  }

  

  Future<void> sendPasswordResetCode(String phoneOrEmail) async {
    await _authRepository.sendPasswordResetCode(phoneOrEmail);
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    await _authRepository.confirmPasswordReset(code, newPassword);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}