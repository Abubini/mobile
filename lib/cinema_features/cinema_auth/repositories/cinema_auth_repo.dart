import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CinemaAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Normal email/phone + password login
  Future<User?> login(String phoneOrEmail, String password) async {
    try {
      final isEmail = phoneOrEmail.contains('@');
      final email = isEmail ? phoneOrEmail : '$phoneOrEmail@cinema.com';
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
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

  // Normal signup with phone converted to email
   Future<User?> signup(String name, String phone, String password, String location) async {
  User? user;
  try {
    
    // Validate inputs
    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(phone)) {
      throw 'Please enter a valid phone number (7-15 digits)';
    }
    if (password.length < 6) {
      throw 'Password must be at least 6 characters';
    }

    // Create user in Firebase Auth
    final email = '$phone@cinema.com';
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    // Update user profile
    await user?.updateProfile(displayName: name);
    await user?.reload();

    // Save additional data to Firestore - don't throw if this fails
    try {
      await _saveUserDataToFirestore(
        userId: user!.uid,
        name: name,
        phone: phone,
        location: location,
        email: email,
      );
    } catch (e) {
      debugPrint('Firestore save failed but user was created: $e');
      // Continue even if Firestore fails
    }

    return user;
  } on FirebaseAuthException catch (e) {
    debugPrint('Signup error: ${e.code} - ${e.message}');
    throw _getSignupErrorMessage(e);
  } catch (e) {
    debugPrint('Signup error: $e');
    // If we created the user but something else failed, delete the user
    if (user != null) {
      try {
        await user.delete();
      } catch (deleteError) {
        debugPrint('Failed to delete user after failed signup: $deleteError');
      }
    }
    throw 'Failed to create account. Please try again.';
  }
}

  Future<void> _saveUserDataToFirestore({
    required String userId,
    required String name,
    required String phone,
    required String location,
    required String email,
  }) async {
    try {
      await _firestore.collection('cinemas').doc(userId).set({
        'name': name,
        'phone': phone,
        'location': location,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'role': 'cinema_admin',
      });
    } catch (e) {
      debugPrint('Firestore save error: $e');
      throw 'Failed to save user data. Account was created but some details may be missing.';
    }
  }
  String _getSignupErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This phone number is already registered';
      case 'invalid-email':
        return 'Invalid phone number format';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'Failed to create account. Please try again.';
    }
  }

  // Password reset
  Future<void> sendPasswordResetCode(String phoneOrEmail) async {
    try {
      final isEmail = phoneOrEmail.contains('@');
      final email = isEmail ? phoneOrEmail : '$phoneOrEmail@cinema.com';
      
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      throw _authError(e.code);
    } catch (e) {
      debugPrint('Password reset error: $e');
      throw 'Failed to send reset code. Please try again.';
    }
  }

  // Verify password reset code
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(
        code: code.trim(),
        newPassword: newPassword.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Password confirm error: ${e.code} - ${e.message}');
      throw _authError(e.code);
    } catch (e) {
      debugPrint('Password confirm error: $e');
      throw 'Failed to reset password. Please try again.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Helper method to convert Firebase error codes to user-friendly messages
  String _authError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email or phone number format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with these credentials';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This phone number is already registered';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}