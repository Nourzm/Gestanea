import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/gradient_pill_button.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_event.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/auth/presentation/widgets/hero_section.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
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
  bool _agreedToTerms = false; // New state for the checkbox

  void _onSignupPressed() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms and Privacy Policy'),
        ),
      );
      return;
    }

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
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, AppRoutes.personalize);
            } else if (state is AuthFailure) {
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
                                    t.your_name, // Changed from t.your_name to t.full_name if available, otherwise keep t.your_name or manually set "Full Name"
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
                                    hintText: t
                                        .enter_name, // Should be something like "Sarah Johnson"
                                    prefixIcon: Icons
                                        .person_outlined, // Changed to outline icon to match image
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  // Email address label
                                  Text(
                                    t.email, // Changed to t.email_address to match image
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
                                    hintText: t
                                        .enter_email, // Should be "sarah@example.com"
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
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
                                  Stack(
                                    children: [
                                      InputField(
                                        controller: _passwordController,
                                        hintText: t.password,
                                        prefixIcon: Icons.lock_outline,
                                        obscureText: true,
                                        // suffixIcon: Icons
                                        //     .visibility_outlined, // Added eye icon
                                      ),
                                      Positioned(
                                        top: 55,
                                        child: Text(
                                          'Must be at least 8 characters', // Added password hint
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: screenHeight * 0.012),

                                  // Terms and Conditions Checkbox
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _agreedToTerms,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            _agreedToTerms = newValue ?? false;
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
                                                  fontWeight: FontWeight.w600,
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
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
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
                                    return GradientPillButton(
                                      label: t.signup,
                                      isLoading: isLoading,
                                      onPressed:
                                          isLoading ? null : _onSignupPressed,
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
