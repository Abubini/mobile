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
  final _forgotPasswordPhoneController = TextEditingController();
  final _codeController = TextEditingController();

  bool _showForgotPasswordSection = false;
  bool _codeSent = false;
  bool _isLoading = false;

  Future<void> _handleForgotPassword() async {
    if (!_forgotPasswordPhoneController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate sending code
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _codeSent = true;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Code sent to ${_forgotPasswordPhoneController.text}')),
    );
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate code verification
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP verification successful')),
    );

    if (context.mounted) {
      context.go('/cinema/dashboard');
    }
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
                  _showForgotPasswordSection = true;
                  _codeSent = false;
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final authProvider = Provider.of<CinemaAuthProvider>(context, listen: false);
                final success = await authProvider.login(
                  _phoneController.text,
                  _passwordController.text,
                );
                if (success && context.mounted) {
                  context.push('/cinema/scan');
                }
              }
            },
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
          _showForgotPasswordSection = false;
          _codeSent = false;
          _forgotPasswordPhoneController.clear();
          _codeController.clear();
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
                    _showForgotPasswordSection = false;
                    _codeSent = false;
                    _forgotPasswordPhoneController.clear();
                    _codeController.clear();
                  });
                },
              ),
              const SizedBox(width: 8),
              Text(
                _codeSent ? 'Enter Code' : 'Forgot Password',
                style: AppStyles.heading2,
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _codeSent ? _codeController : _forgotPasswordPhoneController,
            decoration: InputDecoration(
              labelText: _codeSent ? 'Enter 6-digit code' : 'Phone Number',
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
            text: _codeSent ? 'Verify' : 'Send Code',
            onPressed: _isLoading
                ? (){}
                : _codeSent
                    ? _verifyCode
                    : _handleForgotPassword,
            isDisabled: _isLoading,
          ),
          if (_isLoading) const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }

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
            child: _showForgotPasswordSection
                ? _buildForgotPasswordSection()
                : _buildLoginSection(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _forgotPasswordPhoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}