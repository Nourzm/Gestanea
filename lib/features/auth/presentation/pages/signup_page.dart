import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/neumorphic_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:gestanea/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _termsError;

  @override
  void initState() {
    super.initState();

    // Clear errors when user starts typing
    _nameController.addListener(() {
      if (_nameError != null) {
        setState(() {
          _nameError = null;
        });
      }
    });

    _emailController.addListener(() {
      if (_emailError != null) {
        setState(() {
          _emailError = null;
        });
      }
    });

    _passwordController.addListener(() {
      if (_passwordError != null) {
        setState(() {
          _passwordError = null;
        });
      }
    });
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _onSignupPressed() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate inputs
    setState(() {
      _nameError = _validateName(name);
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
      _termsError = !_agreedToTerms
          ? 'You must agree to the Terms and Privacy Policy'
          : null;
    });

    if (_nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _termsError != null) {
      return;
    }

    // Trigger sign up
    context.read<AuthBloc>().add(
      SignUpRequested(name: name, email: email, password: password),
    );
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = screenWidth * 0.038;
    final linkColor = AppColors.main600;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        top: false,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              // NEW user - go to OTP
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OTPVerificationPage(email: state.email),
                ),
              );
            } else if (state is AuthFailure) {
              final message = state.message.replaceAll('Exception: ', '');

              if (message == 'account_exists') {
                // EXISTING user - show error and redirect to login
                setState(() {
                  _emailError = 'This email is already registered';
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'You already have an account. Please log in.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );

                // Redirect to login after 2 seconds
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                });
              } else {
                // For other errors, show them as field errors instead of snackbars
                setState(() {
                  if (message.toLowerCase().contains('email')) {
                    _emailError = 'Invalid email address';
                  } else if (message.toLowerCase().contains('password')) {
                    _passwordError = 'Invalid password';
                  } else if (message.toLowerCase().contains('name')) {
                    _nameError = 'Invalid name';
                  } else {
                    // Generic error - show below email as it's most likely related
                    _emailError = message;
                  }
                });
              }
            }
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const HeroSection(
                      title: "Create Account",
                      subtitle: "Start your journey with us today",
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
                            // Input fields and checkbox
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Full Name label
                                  Text(
                                    t.your_name,
                                    style: TextStyle(
                                      fontSize: labelFontSize.clamp(14.0, 16.0),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.012),

                                  // Full Name input
                                  InputField(
                                    controller: _nameController,
                                    hintText: t.enter_name,
                                    prefixIcon: Icons.person_outlined,
                                    errorText: _nameError,
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  // Email address label
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
                                    keyboardType: TextInputType.emailAddress,
                                    errorText: _emailError,
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  // Password label
                                  Text(
                                    t.password,
                                    style: TextStyle(
                                      fontSize: labelFontSize.clamp(14.0, 16.0),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.012),

                                  // Password input
                                  InputField(
                                    controller: _passwordController,
                                    hintText: t.password,
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    errorText: _passwordError,
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  // Terms and Conditions Checkbox
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _agreedToTerms,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                _agreedToTerms =
                                                    newValue ?? false;
                                                if (_agreedToTerms) {
                                                  _termsError = null;
                                                }
                                              });
                                            },
                                            activeColor: linkColor,
                                          ),
                                          Expanded(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Text(
                                                  'I agree to the ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Handle Terms & Conditions tap
                                                  },
                                                  child: Text(
                                                    'Terms & Conditions',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: linkColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ' and ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Handle Privacy Policy tap
                                                  },
                                                  child: Text(
                                                    'Privacy Policy',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: linkColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_termsError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 52,
                                            top: 4,
                                          ),
                                          child: Text(
                                            _termsError!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state is AuthLoading;
                                    return NeumorphicButton(
                                      text: t.signup,
                                      onPressed: isLoading
                                          ? null
                                          : _onSignupPressed,
                                      isLoading: isLoading,
                                    );
                                  },
                                ),

                                SizedBox(height: screenHeight * 0.015),

                                // Already have an Account
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _goToLogin,
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: linkColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
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
