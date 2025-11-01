import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pregnancy_baby_app/core/services/local_storage_service.dart';
import 'package:pregnancy_baby_app/core/constants/app_strings.dart';

/// User mode enum
enum UserMode {
  pregnancy,
  baby,
  both,
  none,
}

/// User mode state notifier
class UserModeNotifier extends StateNotifier<UserMode> {
  final LocalStorageService _storageService;

  UserModeNotifier(this._storageService) : super(UserMode.none) {
    _loadUserMode();
  }

  /// Load user mode from storage
  Future<void> _loadUserMode() async {
    final modeString = _storageService.getString('user_mode');
    if (modeString != null) {
      state = UserMode.values.firstWhere(
        (mode) => mode.toString() == modeString,
        orElse: () => UserMode.none,
      );
    }
  }

  /// Set user mode to pregnancy tracking
  Future<void> setPregnancyMode() async {
    state = UserMode.pregnancy;
    await _storageService.setString('user_mode', state.toString());
  }

  /// Set user mode to baby care
  Future<void> setBabyMode() async {
    state = UserMode.baby;
    await _storageService.setString('user_mode', state.toString());
  }

  /// Set user mode to both pregnancy and baby care
  Future<void> setBothMode() async {
    state = UserMode.both;
    await _storageService.setString('user_mode', state.toString());
  }

  /// Clear user mode
  Future<void> clearMode() async {
    state = UserMode.none;
    await _storageService.remove('user_mode');
  }

  /// Check if user is in pregnancy mode
  bool get isPregnancyMode => state == UserMode.pregnancy || state == UserMode.both;

  /// Check if user is in baby mode
  bool get isBabyMode => state == UserMode.baby || state == UserMode.both;

  /// Check if user has selected a mode
  bool get hasModeSelected => state != UserMode.none;
}

/// User mode provider
final userModeProvider = StateNotifierProvider<UserModeNotifier, UserMode>((ref) {
  return UserModeNotifier(LocalStorageService.instance);
});
