import 'package:cinema_app/features/auth/data/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  final AuthRepository _authRepository = AuthRepository();

  bool get isAuthenticated => _isAuthenticated;

  Future<User?> login(String phone, String password) async {
    try {
      final user = await _authRepository.login(phone, password);
      _isAuthenticated = user != null;
      notifyListeners();
      return user;
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<User?> signup(String username, String phone, String password) async {
    try {
      final user = await _authRepository.signup(username, phone, password);
      _isAuthenticated = user != null;
      notifyListeners();
      return user;
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> sendPasswordResetCode(String phone) async {
    await _authRepository.sendPasswordResetCode(phone);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}