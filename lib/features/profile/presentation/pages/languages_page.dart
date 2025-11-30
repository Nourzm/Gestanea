import 'package:flutter/material.dart';
// Import the modified MyApp to access the state method
import 'package:gestanea/app.dart';

// --- Theme Colors (Matching the Profile Page Design) ---
const Color kPrimaryPurple = Color(0xFF7B3CA4);
const Color kInactiveText = Color(0xFFAC5DCC);
const Color kShadowColor = Color(0x3F000000);

// -----------------------------------------------------------------
// --- Language Selection Screen ---
// -----------------------------------------------------------------

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  // Data map for our supported languages
  final Map<String, LanguageData> availableLanguages = const {
    'en': LanguageData(
      locale: Locale('en'), // Match your MyApp's Locale format
      flag: '🇬🇧',
      name: 'English',
      nativeName: 'English',
    ),
    'fr': LanguageData(
      locale: Locale('fr'),
      flag: '🇫🇷',
      name: 'French',
      nativeName: 'Français',
    ),
    'ar': LanguageData(
      locale: Locale('ar'),
      flag: '🇸🇦',
      name: 'Arabic',
      nativeName: 'العربية',
    ),
  };

  @override
  Widget build(BuildContext context) {
    // Read the current locale from the MaterialApp widget itself
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Language Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your preferred language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kInactiveText,
                ),
              ),
              const SizedBox(height: 20),

              // Language Options Group
              _LanguageOptionsGroup(
                children: availableLanguages.values.map((langData) {
                  return LanguageOptionTile(
                    language: langData,
                    // Check if the tile's language code matches the currently active one
                    isSelected:
                        langData.locale.languageCode ==
                        currentLocale.languageCode,
                    onTap: () {
                      // THIS IS THE CRUCIAL FUNCTION CALL
                      // 3. Call the exposed setLocale function on MyApp
                      MyApp.setAppLocale(context, langData.locale);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Note: Changing the language will immediately refresh the application.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- Helper Widgets (from previous response) ---
// -----------------------------------------------------------------

class LanguageData {
  final Locale locale;
  final String flag;
  final String name;
  final String nativeName;

  const LanguageData({
    required this.locale,
    required this.flag,
    required this.name,
    required this.nativeName,
  });
}

class _LanguageOptionsGroup extends StatelessWidget {
  final List<Widget> children;
  const _LanguageOptionsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: children.map((item) {
          int index = children.indexOf(item);
          return Column(
            children: [
              item,
              if (index < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey[200],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class LanguageOptionTile extends StatelessWidget {
  final LanguageData language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),

      leading: Text(language.flag, style: const TextStyle(fontSize: 28)),

      title: Text(
        language.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),

      subtitle: language.name != language.nativeName
          ? Text(
              language.nativeName,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            )
          : null,

      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryPurple,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            )
          : const Icon(Icons.radio_button_off, color: Colors.grey, size: 20),
    );
  }
}
