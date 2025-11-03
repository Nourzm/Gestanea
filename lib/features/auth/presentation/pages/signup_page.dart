import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
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
    final safeAreaTop = MediaQuery.of(context).padding.top;

    // Responsive sizing
    final headerHeight = screenHeight * 0.3;
    final welcomeFontSize = screenWidth * 0.08;
    final loginFontSize = screenWidth * 0.045;
    final labelFontSize = screenWidth * 0.038;
    // final bodyFontSize = screenWidth * 0.035;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Top section with image and welcome text
                  SizedBox(
                    height: headerHeight.clamp(180.0, 300.0),
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/login.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: AppColors.main600);
                            },
                          ),
                        ),

                        // Back button
                        Positioned(
                          top: safeAreaTop + 10,
                          left: screenWidth * 0.04,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),

                        // Welcome text
                        Positioned(
                          left: screenWidth * 0.1,
                          bottom: screenHeight * 0.08,
                          right: screenWidth * 0.1,
                          child: Text(
                            t.welcome_back,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: welcomeFontSize.clamp(24.0, 36.0),
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // LOG IN text
                        Positioned(
                          left: screenWidth * 0.1,
                          bottom: screenHeight * 0.035,
                          right: screenWidth * 0.1,
                          child: Text(
                            t.login,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: loginFontSize.clamp(16.0, 20.0),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
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
                                // name label
                                Text(
                                  t.your_name,
                                  style: TextStyle(
                                    fontSize: labelFontSize.clamp(14.0, 16.0),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.012),

                                // name input
                                InputField(
                                  controller: _nameController,
                                  hintText: t.enter_name,
                                  prefixIcon: Icons.person_2_outlined,
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
                                ),
                              ],
                            ),
                          ),

                          // Bottom section with button and login link
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: screenHeight * 0.02),

                              // Signup button
                              AppButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.dashboard,
                                  );
                                },
                                text: t.signup,
                              ),

                              // Already have an Account
                              SizedBox(height: screenHeight * 0.01),
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
    );
  }
}
