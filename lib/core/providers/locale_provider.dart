import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pregnancy_baby_app/core/services/local_storage_service.dart';
import 'package:pregnancy_baby_app/core/constants/app_strings.dart';

/// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  final LocalStorageService _storageService;

  LocaleNotifier(this._storageService) : super(const Locale('en')) {
    _loadLocale();
  }

  /// Load locale from storage
  Future<void> _loadLocale() async {
    final localeString = _storageService.getString(AppStrings.prefKeyLocale);
    if (localeString != null) {
      state = Locale(localeString);
    }
  }

  /// Set locale to English
  Future<void> setEnglish() async {
    state = const Locale('en');
    await _storageService.setString(AppStrings.prefKeyLocale, 'en');
  }

  /// Set locale to French
  Future<void> setFrench() async {
    state = const Locale('fr');
    await _storageService.setString(AppStrings.prefKeyLocale, 'fr');
  }

  /// Set locale to Arabic
  Future<void> setArabic() async {
    state = const Locale('ar');
    await _storageService.setString(AppStrings.prefKeyLocale, 'ar');
  }

  /// Set custom locale
  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await _storageService.setString(AppStrings.prefKeyLocale, languageCode);
  }

  /// Get current language name
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  /// Get current language code
  String get currentLanguageCode => state.languageCode;

  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';

  /// Check if current locale is French
  bool get isFrench => state.languageCode == 'fr';

  /// Check if current locale is Arabic
  bool get isArabic => state.languageCode == 'ar';

  /// Check if current locale is RTL
  bool get isRtl => state.languageCode == 'ar';
}

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(LocalStorageService.instance);
});
