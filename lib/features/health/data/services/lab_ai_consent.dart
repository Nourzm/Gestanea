import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the user has accepted the one-time disclaimer before using
/// AI lab interpretation. Educational-not-diagnostic consent is a requirement
/// for shipping medical-adjacent AI features.
class LabAiConsent {
  static const _key = 'lab_ai_consent_accepted_v1';

  static Future<bool> hasAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
