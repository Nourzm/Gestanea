import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_routes.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final imageSize = (screenHeight * 0.22).clamp(150.0, 220.0);
    final titleFontSize = (screenWidth * 0.06).clamp(20.0, 28.0);
    final subtitleFontSize = (screenWidth * 0.035).clamp(12.0, 16.0);
    final orFontSize = (screenWidth * 0.045).clamp(16.0, 20.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.03,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Add flexible spacing at top
                          SizedBox(height: screenHeight * 0.05),

                          // Image
                          Image.asset(
                            'assets/images/fetus.png',
                            height: imageSize,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: imageSize,
                                width: imageSize,
                                decoration: BoxDecoration(
                                  color: AppColors.main700.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: imageSize * 0.5,
                                  color: AppColors.main700.withOpacity(0.3),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Main title
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            child: Text(
                              t.auth,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.main700,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.035),

                          // Subtitle
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            child: Text(
                              t.auth2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.main700,
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.06),

                          // Login button
                          AppButton(
                            text: "Login",
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            filled: false,
                            maxWidth: 500, // optional
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // OR text
                          Text(
                            t.or,
                            style: TextStyle(
                              color: AppColors.main700,
                              fontSize: orFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Register button
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: AppButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.signup);
                              },
                              text: t.register,
                            ),
                          ),

                          // Add flexible spacing at bottom
                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
