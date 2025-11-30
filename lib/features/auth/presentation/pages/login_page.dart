import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/features/auth/presentation/widgets/input_fields.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
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
    final headerHeight = screenHeight * 0.35;
    final welcomeFontSize = screenWidth * 0.08;
    final loginFontSize = screenWidth * 0.045;
    final labelFontSize = screenWidth * 0.038;
    final bodyFontSize = screenWidth * 0.035;

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
                    height: headerHeight.clamp(200.0, 350.0),
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/login.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: AppColors.main500);
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

                                SizedBox(height: screenHeight * 0.025),

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

                                SizedBox(height: screenHeight * 0.015),

                                // Remember me and Forgot password
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (value) {
                                                setState(() {
                                                  _rememberMe = value ?? false;
                                                });
                                              },
                                              activeColor: AppColors.main400,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              t.rememberMe,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: bodyFontSize.clamp(
                                                  12.0,
                                                  14.0,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          minimumSize: const Size(0, 36),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          t.forgot,
                                          style: TextStyle(
                                            color: AppColors.main600,
                                            fontSize: bodyFontSize.clamp(
                                              12.0,
                                              14.0,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Bottom section with button and signup link
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: screenHeight * 0.02),

                              // Login button
                              AppButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.dashboard,
                                  );
                                },
                                text: t.login,
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Create an Account
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      t.notRegistered,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: bodyFontSize.clamp(
                                          12.0,
                                          14.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppRoutes.signup,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        t.createAccount,
                                        style: TextStyle(
                                          color: AppColors.main600,
                                          fontSize: bodyFontSize.clamp(
                                            12.0,
                                            14.0,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
