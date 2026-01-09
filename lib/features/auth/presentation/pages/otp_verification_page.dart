import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
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
/// - To request OTP: context.read<AuthBloc>().add(SendOtpRequested(email: email))
/// - To verify OTP: context.read<AuthBloc>().add(VerifyOtpRequested(email: email, otpCode: code))
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  void _onSendOtpPressed() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }

    // Send OTP request
    context.read<AuthBloc>().add(SendOtpRequested(email: email));
  }

  void _onVerifyOtpPressed() {
    final email = _emailController.text.trim();
    final code = _otpController.text.trim();

    if (code.isEmpty || code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    // Verify OTP
    context.read<AuthBloc>().add(
      VerifyOtpRequested(email: email, otpCode: code),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = screenWidth * 0.038;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        top: false,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              // OTP sent successfully
              setState(() {
                _otpSent = true;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(t.otpSent)));
            } else if (state is AuthAuthenticated) {
              // Successfully authenticated
              Navigator.pushReplacementNamed(context, AppRoutes.personalize);
            } else if (state is AuthFailure) {
              // Show error message
              final message = state.message.replaceAll('Exception: ', '');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const HeroSection(
                      title: "Email Verification",
                      subtitle: "We'll send you a verification code",
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Input fields
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Email label
                                  Text(
                                    t.email,
                                    style: TextStyle(
                                      fontSize: labelFontSize.clamp(14.0, 16.0),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.012),

                                  // Email input
                                  InputField(
                                    controller: _emailController,
                                    hintText: t.enter_email,
                                    prefixIcon: Icons.email_outlined,
                                  ),

                                  if (_otpSent) ...[
                                    SizedBox(height: screenHeight * 0.02),

                                    // OTP Code label
                                    Text(
                                      t.enterOtpCode,
                                      style: TextStyle(
                                        fontSize: labelFontSize.clamp(
                                          14.0,
                                          16.0,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.012),

                                    // OTP Code input
                                    InputField(
                                      controller: _otpController,
                                      hintText: t.otpCodePlaceholder,
                                      prefixIcon: Icons.lock_outlined,
                                      keyboardType: TextInputType.number,
                                    ),

                                    // Resend OTP link
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _onSendOtpPressed,
                                        child: Text(
                                          t.resendOtp,
                                          style: const TextStyle(
                                            color: AppColors.main600,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Action button
                            Column(
                              children: [
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state is AuthLoading;

                                    return AppButton(
                                      onPressed: isLoading
                                          ? () {}
                                          : (_otpSent
                                                ? _onVerifyOtpPressed
                                                : _onSendOtpPressed),
                                      text: isLoading
                                          ? 'Loading...'
                                          : (_otpSent
                                                ? t.verifyOtp
                                                : t.sendOtp),
                                    );
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.02),

                                // Back to login link
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                                  child: Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      color: AppColors.main600,
                                      fontSize: labelFontSize.clamp(13.0, 15.0),
                                    ),
                                  ),
                                ),
                              ],
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
