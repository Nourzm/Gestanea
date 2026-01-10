import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyCurrentUserId = 'current_user_id';

  Future<void> saveCurrentUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUserId, id);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentUserId);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUserId);
  }
}
