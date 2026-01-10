import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/l10n/app_localizations.dart';

/// OTP Verification Page
///
/// This page handles the OTP verification flow:
/// 1. User enters their email
/// 2. Taps "Send Code" to request OTP
/// 3. Enters the 6-digit code received via email
/// 4. Taps "Verify Code" to authenticate
///
/// Usage:
class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({super.key, required this.email});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;
  String? _otpError; // Inline error for OTP validation

  @override
  void initState() {
    super.initState();
    for (final node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _clearError() {
    if (_otpError != null) {
      setState(() {
        _otpError = null;
      });
    }
  }

  void _verifyOTP() {
    if (_otpCode.length == 6) {
      _clearError();
      context.read<AuthBloc>().add(
        VerifyOtpRequested(email: widget.email, otpCode: _otpCode),
      );
    } else {
      setState(() {
        _otpError = 'Please enter the complete 6-digit code';
      });
    }
  }

  void _resendOTP() {
    if (_canResend) {
      context.read<AuthBloc>().add(ResendOtpRequested(email: widget.email));
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        top: false,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, AppRoutes.personalize);
            } else if (state is AuthFailure) {
              final message = state.message.replaceAll('Exception: ', '');
              
              // Map error keys to user-friendly messages
              String errorMessage;
              if (message == 'noInternetConnection') {
                // Network errors: show in SnackBar (global issue)
                errorMessage = t.noInternetConnection;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
                return; // Don't show inline error for network issues
              } else if (message.toLowerCase().contains('invalid') ||
                         message.toLowerCase().contains('expired') ||
                         message.toLowerCase().contains('code') ||
                         message.toLowerCase().contains('token')) {
                // OTP validation errors: show inline below OTP fields
                setState(() {
                  _otpError = 'Invalid or expired code. Please try again.';
                });
              } else {
                // Other errors: show inline
                setState(() {
                  _otpError = 'Verification failed. Please try again.';
                });
              }
            } else if (state is AuthOTPResent) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.otpSent),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const HeroSection(
                      title: "Verify Email",
                      subtitle: "Enter the code we sent you",
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: screenHeight * 0.04,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'We sent a 6-digit code to',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.main600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),

                                // OTP Input Boxes
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(6, (index) {
                                    return _OTPBox(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      onChanged: (value) {
                                        _clearError(); // Clear error when user types
                                        
                                        if (value.isNotEmpty && index < 5) {
                                          // Auto-advance to next field
                                          _focusNodes[index + 1].requestFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          // Move back on backspace
                                          _focusNodes[index - 1].requestFocus();
                                        }

                                        if (_otpCode.length == 6) {
                                          _verifyOTP();
                                        }
                                      },
                                    );
                                  }),
                                ),
                                // Inline error display below OTP fields
                                if (_otpError != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    _otpError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                const SizedBox(height: 32),

                                // Resend button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive the code?  ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _canResend ? _resendOTP : null,
                                      child: Text(
                                        _canResend
                                            ? 'Resend'
                                            : 'Resend in $_resendTimer s',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _canResend
                                              ? AppColors.main600
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Verify Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _verifyOTP,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.main600,
                                      disabledBackgroundColor: Colors.grey[300],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Verify Email',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OTPBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OTPBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focusNode.hasFocus ? AppColors.main600 : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) {
          // Prevent multiple characters
          if (value.length > 1) {
            controller.text = value.substring(0, 1);
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          }
          onChanged(controller.text);
        },
        onTap: () {
          // Select all text when tapping on a field
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.main600,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
