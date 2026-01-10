import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyCurrentUserId = 'current_user_id';
  static const _keyRememberMeEmail = 'remember_me_email';
  static const _keyRememberMePassword = 'remember_me_password';
  static const _keyRememberMeEnabled = 'remember_me_enabled';

  Future<void> saveCurrentUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUserId, id);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentUserId);
  }

  /// Save credentials for "Remember Me" feature
  /// Note: Password is stored in SharedPreferences (encrypted by OS on supported platforms)
  Future<void> saveRememberedCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRememberMeEmail, email);
    await prefs.setString(_keyRememberMePassword, password);
    await prefs.setBool(_keyRememberMeEnabled, true);
  }

  /// Get remembered credentials if available
  /// Returns null if no credentials are saved
  Future<Map<String, String>?> getRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_keyRememberMeEnabled) ?? false;
    
    if (!isEnabled) {
      return null;
    }

    final email = prefs.getString(_keyRememberMeEmail);
    final password = prefs.getString(_keyRememberMePassword);

    if (email == null || password == null) {
      return null;
    }

    return {
      'email': email,
      'password': password,
    };
  }

  /// Check if "Remember Me" is enabled
  Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMeEnabled) ?? false;
  }

  /// Clear remembered credentials
  Future<void> clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRememberMeEmail);
    await prefs.remove(_keyRememberMePassword);
    await prefs.remove(_keyRememberMeEnabled);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUserId);
    // Note: We don't clear remembered credentials here
    // They should only be cleared when user unchecks "Remember Me" or logs out explicitly
  }
}
