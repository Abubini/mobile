import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String phone, String password) async {
    try {
      // Convert phone to email format
      final email = '$phone@user.com';
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      throw _authError(e.code);
    } catch (e) {
      debugPrint('Login error: $e');
      throw 'Failed to login. Please try again.';
    }
  }

  Future<User?> signup(String username, String phone, String password) async {
    try {
      // Validate phone number format
      if (!RegExp(r'^[0-9]{7,15}$').hasMatch(phone)) {
        throw 'Please enter a valid phone number (7-15 digits)';
      }

      // Validate password length
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      // Create email from phone
      final email = '$phone@user.com';

      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with display name
      await userCredential.user?.updateProfile(displayName: username);
      await userCredential.user?.reload();

      // Save additional user data to Firestore
      if (userCredential.user != null) {
        await _saveUserDataToFirestore(
          userId: userCredential.user!.uid,
          username: username,
          phone: phone,
          email: email,
        );
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Signup error: ${e.code} - ${e.message}');
      throw _authError(e.code);
    } catch (e) {
      debugPrint('Signup error: $e');
      throw 'Failed to create account. Please try again.';
    }
  }

  Future<void> _saveUserDataToFirestore({
    required String userId,
    required String username,
    required String phone,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'phone': phone,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'role': 'user',
      });
    } catch (e) {
      debugPrint('Firestore save error: $e');
      throw 'Failed to save user data. Account was created but some details may be missing.';
    }
  }

  Future<void> sendPasswordResetCode(String phone) async {
    try {
      final email = '$phone@user.com';
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      throw _authError(e.code);
    } catch (e) {
      debugPrint('Password reset error: $e');
      throw 'Failed to send reset code. Please try again.';
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid phone number format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this phone number';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This phone number is already registered';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}