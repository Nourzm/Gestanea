import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_theme_data.dart';

/// State for the theme
class ThemeState {
  final AppThemeData themeData;

  ThemeState(this.themeData);
}

/// Cubit to manage app theming
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(AppThemeData.purpleTheme));

  /// Update theme based on pregnancy state and baby gender
  void updateTheme({required bool isPregnant, String? babyGender}) {
    final themeMode = AppThemeData.determineThemeMode(
      isPregnant: isPregnant,
      babyGender: babyGender,
    );

    final newTheme = AppThemeData.getTheme(themeMode);

    // Only emit if theme actually changed
    if (state.themeData.mode != newTheme.mode) {
      emit(ThemeState(newTheme));
    }
  }

  /// Manually set theme mode (for testing or manual override)
  void setThemeMode(AppThemeMode mode) {
    final newTheme = AppThemeData.getTheme(mode);
    if (state.themeData.mode != newTheme.mode) {
      emit(ThemeState(newTheme));
    }
  }

  /// Get current theme data
  AppThemeData get currentTheme => state.themeData;
}
