import 'package:shared_preferences/shared_preferences.dart';
import 'package:pregnancy_baby_app/core/exceptions/app_exceptions.dart';

class LocalStorageService {
  static SharedPreferences? _preferences;
  static final LocalStorageService instance = LocalStorageService._internal();

  LocalStorageService._internal();

  factory LocalStorageService() => instance;

  /// Initialize shared preferences
  Future<void> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (e) {
      throw StorageException('Failed to initialize local storage: $e');
    }
  }

  SharedPreferences get _prefs {
    if (_preferences == null) {
      throw StorageException('Local storage not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // String operations
  
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      throw StorageException.writeFailed();
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw StorageException.readFailed();
    }
  }

  // Int operations
  
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      throw StorageException.writeFailed();
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw StorageException.readFailed();
    }
  }

  // Double operations
  
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      throw StorageException.writeFailed();
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw StorageException.readFailed();
    }
  }

  // Bool operations
  
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      throw StorageException.writeFailed();
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw StorageException.readFailed();
    }
  }

  // String list operations
  
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      throw StorageException.writeFailed();
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      throw StorageException.readFailed();
    }
  }

  // Remove operations
  
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      throw StorageException.deleteFailed();
    }
  }

  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage: $e');
    }
  }

  // Check if key exists
  
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // Reload preferences (useful after external changes)
  
  Future<void> reload() async {
    try {
      await _prefs.reload();
    } catch (e) {
      throw StorageException('Failed to reload storage: $e');
    }
  }
}
