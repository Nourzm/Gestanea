import 'package:flutter/material.dart';
import 'package:pregnancy_baby_app/core/constants/app_colors.dart';
import 'package:pregnancy_baby_app/core/constants/app_text_styles.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    brightness: Brightness.light,
    
    // Color scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.main600,
      primaryContainer: AppColors.main300,
      secondary: AppColors.pink500,
      secondaryContainer: AppColors.pink200,
      tertiary: AppColors.blue500,
      tertiaryContainer: AppColors.blue200,
      surface: AppColors.white,
      surfaceContainerHighest: AppColors.bg_1,
      error: Colors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.textPrimary,
      onError: AppColors.white,
      outline: AppColors.purpleGrey,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.background,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.main600,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headline2.copyWith(color: AppColors.white),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),

    // Card
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.purpleGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.purpleGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.main600, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: AppTextStyles.unfocusedLabel,
      floatingLabelStyle: AppTextStyles.focusedLabel,
      hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textSecondary.withOpacity(0.6)),
      errorStyle: const TextStyle(fontSize: 12),
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.main600,
        foregroundColor: AppColors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.main600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: AppTextStyles.buttonTextSmall,
      ),
    ),

    // Outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.main600,
        side: const BorderSide(color: AppColors.main600, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    // Icon button
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.main600,
      ),
    ),

    // Floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.main600,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.purpleGrey,
      thickness: 1,
      space: 1,
    ),

    // Dialog
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: AppTextStyles.headline2,
      contentTextStyle: AppTextStyles.body1,
    ),

    // Bottom navigation bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.main600,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Text theme
    textTheme: AppTextStyles.textTheme,

    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.main600,
      size: 24,
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.main600;
        }
        return AppColors.purpleGrey;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.main600;
        }
        return AppColors.purpleGrey;
      }),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.main600;
        }
        return AppColors.purpleGrey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.main300;
        }
        return AppColors.purpleGrey.withOpacity(0.3);
      }),
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.main600,
      inactiveTrackColor: AppColors.main300,
      thumbColor: AppColors.main600,
      overlayColor: AppColors.main600.withOpacity(0.2),
    ),

    // Progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.main600,
      linearTrackColor: AppColors.main300,
      circularTrackColor: AppColors.main300,
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.main700,
      contentTextStyle: AppTextStyles.bodyWhite,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.main300,
      selectedColor: AppColors.main600,
      labelStyle: AppTextStyles.smallLabel,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  // Dark theme (optional - can be implemented later)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    brightness: Brightness.dark,
    // You can customize dark theme later
  );
}
