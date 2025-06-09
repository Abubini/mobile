import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../providers/cinema_auth_provider.dart';
import '../../../../shared/widgets/app_button.dart';

class CinemaLoginScreen extends StatefulWidget {
  const CinemaLoginScreen({super.key});

  @override
  State<CinemaLoginScreen> createState() => _CinemaLoginScreenState();
}

class _CinemaLoginScreenState extends State<CinemaLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // For password reset
  final _resetPhoneController = TextEditingController();
  final _resetCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  bool _showForgotPassword = false;
  bool _isLoading = false;
  int _resetStep = 0; // 0 = enter phone, 1 = enter code, 2 = enter new password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _showForgotPassword 
                ? _buildForgotPasswordSection()
                : _buildLoginSection(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'CINEMA LOGIN',
            style: AppStyles.heading1.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              labelStyle: AppStyles.mutedText,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: AppStyles.mutedText,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showForgotPassword = true;
                  _resetStep = 0;
                });
              },
              child: Text(
                'Forgot Password?',
                style: AppStyles.bodyText.copyWith(color: AppColors.accentBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'LOGIN',
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          if (_isLoading) const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go('/cinema/signup'),
            child: Text(
              "Don't have an account? Sign up",
              style: AppStyles.bodyText.copyWith(color: AppColors.accentBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordSection() {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _showForgotPassword = false;
          _resetStep = 0;
        });
        return false;
      },
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
                onPressed: () {
                  setState(() {
                    _showForgotPassword = false;
                    _resetStep = 0;
                  });
                },
              ),
              const SizedBox(width: 8),
              Text(
                _resetStep == 0 ? 'Reset Password' 
                  : _resetStep == 1 ? 'Enter Code' 
                  : 'New Password',
                style: AppStyles.heading2,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          if (_resetStep == 0) ...[
            TextFormField(
              controller: _resetPhoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: AppStyles.mutedText,
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'SEND CODE',
              onPressed: _sendResetCode,
              isLoading: _isLoading,
            ),
          ],
          
          if (_resetStep == 1) ...[
            Text(
              'Enter the 6-digit code sent to ${_resetPhoneController.text}',
              style: AppStyles.bodyText,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _resetCodeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                labelStyle: AppStyles.mutedText,
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'VERIFY CODE',
              onPressed: () => setState(() => _resetStep = 2),
              isLoading: _isLoading,
            ),
          ],
          
          if (_resetStep == 2) ...[
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: AppStyles.mutedText,
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                labelStyle: AppStyles.mutedText,
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'RESET PASSWORD',
              onPressed: _resetPassword,
              isLoading: _isLoading,
            ),
          ],
          
          if (_isLoading) const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<CinemaAuthProvider>(context, listen: false);
      await authProvider.login(
        _phoneController.text,
        _passwordController.text,
      );
      
      if (context.mounted) {
        context.go('/cinema/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendResetCode() async {
    if (_resetPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<CinemaAuthProvider>(context, listen: false);
      await authProvider.sendPasswordResetCode(_resetPhoneController.text);
      
      setState(() => _resetStep = 1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset code sent to ${_resetPhoneController.text}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text.isEmpty || _newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<CinemaAuthProvider>(context, listen: false);
      await authProvider.confirmPasswordReset(
        _resetCodeController.text,
        _newPasswordController.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successful! Please login')),
      );
      
      if (context.mounted) {
        setState(() {
          _showForgotPassword = false;
          _resetStep = 0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _resetPhoneController.dispose();
    _resetCodeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}