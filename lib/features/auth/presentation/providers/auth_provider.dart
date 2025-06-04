import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String phone, String password) async {
    // Implement your authentication logic here
    await Future.delayed(const Duration(seconds: 1)); // Simulate network call
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<void> signup(String username, String phone, String password) async {
    // Implement your signup logic here
    await Future.delayed(const Duration(seconds: 1)); // Simulate network call
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}