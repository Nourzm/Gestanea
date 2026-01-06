import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Enum to represent different theme modes based on pregnancy status
enum AppThemeMode {
  purple, // Default - pregnant, gender not revealed
  blue, // Baby is a boy
  pink, // Baby is a girl
}

/// Custom theme class that holds all theme-specific colors
class AppThemeData {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color lightColor;
  final Color darkColor;
  final Color buttonColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Gradient primaryGradient;
  final AppThemeMode mode;

  const AppThemeData({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.lightColor,
    required this.darkColor,
    required this.buttonColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.primaryGradient,
    required this.mode,
  });

  /// Purple Theme - Default for pregnant users (gender not revealed)
  static const AppThemeData purpleTheme = AppThemeData(
    mode: AppThemeMode.purple,
    primaryColor: AppColors.main500, // #B077E5
    secondaryColor: AppColors.main600, // #9D42E8
    accentColor: AppColors.main400, // #9C77BE
    backgroundColor: AppColors.bg_1, // #FDF5FF
    cardColor: AppColors.main300, // #FBECFF
    lightColor: AppColors.background, // #F9E3FF
    darkColor: AppColors.main700, // #3A0E40
    buttonColor: AppColors.main500, // #B077E5
    textPrimaryColor: AppColors.textPrimary,
    textSecondaryColor: AppColors.main400,
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.main500, AppColors.main600],
    ),
  );

  /// Blue Theme - For baby boy
  static const AppThemeData blueTheme = AppThemeData(
    mode: AppThemeMode.blue,
    primaryColor: AppColors.blue500, // #6AB4FF
    secondaryColor: AppColors.blue600, // #3D9EFF
    accentColor: AppColors.blue400, // #91C8FF
    backgroundColor: AppColors.bg_1, // #FDF5FF (keeping same light background)
    cardColor: AppColors.blue300, // #C2E0FF
    lightColor: AppColors.blue200, // #E1F0FF
    darkColor: Color(0xFF1E5A8E), // Darker blue
    buttonColor: AppColors.blue500, // #6AB4FF
    textPrimaryColor: AppColors.textPrimary,
    textSecondaryColor: AppColors.blue600,
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.blue500, AppColors.blue600],
    ),
  );

  /// Pink Theme - For baby girl
  static const AppThemeData pinkTheme = AppThemeData(
    mode: AppThemeMode.pink,
    primaryColor: AppColors.pink500, // #FF91C7
    secondaryColor: AppColors.pink600, // #FB64B6
    accentColor: AppColors.pink400, // #FDA5D5
    backgroundColor: AppColors.bg_1, // #FDF5FF (keeping same light background)
    cardColor: AppColors.pink300, // #FBD4F6
    lightColor: AppColors.pink200, // #F9E3FF
    darkColor: Color(0xFF8B2E5F), // Darker pink
    buttonColor: AppColors.pink500, // #FF91C7
    textPrimaryColor: AppColors.textPrimary,
    textSecondaryColor: AppColors.pink600,
    primaryGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.pink500, AppColors.pink600],
    ),
  );

  /// Get theme by mode
  static AppThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.purple:
        return purpleTheme;
      case AppThemeMode.blue:
        return blueTheme;
      case AppThemeMode.pink:
        return pinkTheme;
    }
  }

  /// Determine theme based on pregnancy state and baby gender
  /// Returns purple for pregnant (default), blue for boy, pink for girl
  static AppThemeMode determineThemeMode({
    required bool isPregnant,
    String? babyGender,
  }) {
    // If not pregnant and baby gender is specified, use gender-specific theme
    if (!isPregnant && babyGender != null) {
      if (babyGender.toLowerCase() == 'girl') {
        return AppThemeMode.pink;
      } else if (babyGender.toLowerCase() == 'boy') {
        return AppThemeMode.blue;
      }
    }
    // Default to purple theme for pregnant users or when gender is not revealed
    return AppThemeMode.purple;
  }

  /// Convert AppThemeData to Flutter ThemeData for MaterialApp
  ThemeData toThemeData() {
    return ThemeData(
      fontFamily: 'Lato',
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        error: AppColors.error1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      iconTheme: IconThemeData(color: primaryColor),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
    );
  }
}
