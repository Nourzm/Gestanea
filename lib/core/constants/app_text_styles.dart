import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';

class AppTextStyles {
  // Font family
  static const String fontFamily = 'Lato';

  // Sidebar styles
  static const TextStyle sidebarItem = TextStyle(
    fontFamily: fontFamily,
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Material TextTheme
  static final TextTheme textTheme = TextTheme(
    bodyMedium: const TextStyle(fontFamily: fontFamily, fontSize: 14),
    titleLarge: const TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.bold),
    displayLarge: const TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: const TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: const TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.bold),
    headlineLarge: const TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w600),
    headlineMedium: const TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontFamily: fontFamily, fontSize: 16),
    bodySmall: const TextStyle(fontFamily: fontFamily, fontSize: 12),
    labelLarge: const TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle(fontFamily: fontFamily, fontSize: 10, fontWeight: FontWeight.w500),
  );
  
  // Custom headline styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Subtitle styles
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Body text styles
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.white,
  );

  // Special styles
  static const TextStyle numberHighlight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle smallLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  // Form field styles
  static const TextStyle focusedLabel = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: AppColors.main600,
  );

  static const TextStyle unfocusedLabel = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button text styles
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
