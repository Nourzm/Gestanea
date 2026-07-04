import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/profile/presentation/widgets/neuo_cards.dart';
import 'package:gestanea/l10n/app_localizations.dart';
// Assuming this is your root app file that contains MyApp.setAppLocale
import 'package:gestanea/app.dart';

// --- Language Data Model ---
class LanguageData {
  final Locale locale;
  final String name;
  final String nativeName;

  const LanguageData({
    required this.locale,
    required this.name,
    required this.nativeName,
  });
}

// Data map for supported languages
final Map<String, LanguageData> availableLanguages = const {
  'en': LanguageData(
    locale: Locale('en'),
    name: 'English',
    nativeName: 'English',
  ),
  'fr': LanguageData(
    locale: Locale('fr'),
    name: 'French',
    nativeName: 'Français',
  ),
  'ar': LanguageData(
    locale: Locale('ar'),
    name: 'Arabic',
    nativeName: 'العربية',
  ),
};

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  // This function calls the mechanism (MyApp.setAppLocale) to change the app's global locale.
  void _setLocale(Locale newLocale) {
    // This is the CRUCIAL FUNCTION CALL
    // It assumes MyApp is implemented as a StatefulWidget with a static setAppLocale method
    // (as discussed in the previous response).
    MyApp.setAppLocale(context, newLocale);
  }

  String _localizedName(AppLocalizations t, String code) {
    switch (code) {
      case 'fr':
        return t.french;
      case 'ar':
        return t.arabic;
      default:
        return t.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // Read the current locale from the MaterialApp widget itself
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          t.languages,
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                t.chooseLanguage,
                style: TextStyle(color: AppColors.textDark),
              ),
            ),
            Expanded(
              child: ListView(
                children: availableLanguages.values.map((langData) {
                  // Determine if the current language tile is selected
                  final isSelected =
                      langData.locale.languageCode ==
                      currentLocale.languageCode;

                  return buildNeumorphicTile(
                    primaryText: _localizedName(
                      t,
                      langData.locale.languageCode,
                    ),
                    secondaryText: langData.nativeName,
                    isSelected: isSelected,
                    onTap: () {
                      if (!isSelected) {
                        _setLocale(langData.locale);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
