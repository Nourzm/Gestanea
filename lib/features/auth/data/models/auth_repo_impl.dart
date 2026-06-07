import 'package:gestanea/core/database/models/user_model.dart';
import 'package:gestanea/core/services/supabase_service.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth repository that prefers Supabase Auth when configured, and falls
/// back transparently to the local SQLite credentials store when the app
/// is running fully offline (no `SUPABASE_ANON_KEY`).
///
/// Local `users` table is treated as a per-device cache of the canonical
/// Supabase profile so the dashboard, settings, etc. can read user info
/// synchronously even before the next sync.
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final SessionManager sessionManager;
  final SupabaseService _supabase;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.sessionManager,
    SupabaseService? supabase,
  }) : _supabase = supabase ?? SupabaseService.instance;

  bool get _online => _supabase.isReady;

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    if (_online) {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, if (phone != null) 'phone': phone},
      );
      final user = res.user;
      if (user == null) {
        throw Exception('Sign-up succeeded but no user returned');
      }
      final model = await _upsertLocalUserFrom(
        user,
        nameOverride: name,
        phoneOverride: phone,
      );
      await sessionManager.saveCurrentUserId(model.id);
      return UserEntity.fromModel(model);
    }

    // OFFLINE fallback — local-only account.
    final exists = await localDataSource.emailExists(email);
    if (exists) {
      throw Exception('Email already in use');
    }
    final now = DateTime.now();
    final model = UserModel(
      id: _uuid(),
      email: email,
      name: name,
      phone: phone,
      country: null,
      language: null,
      theme: null,
      notificationsEnabled: true,
      createdAt: now,
      updatedAt: now,
    );
    await localDataSource.createUserWithPassword(
      user: model,
      password: password,
    );
    await sessionManager.saveCurrentUserId(model.id);
    return UserEntity.fromModel(model);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (_online) {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = res.user;
      if (user == null) throw Exception('Invalid credentials');
      final model = await _upsertLocalUserFrom(user);
      await sessionManager.saveCurrentUserId(model.id);
      return UserEntity.fromModel(model);
    }

    // OFFLINE fallback.
    final model = await localDataSource.getUserByEmailAndPassword(
      email,
      password,
    );
    if (model == null) throw Exception('Invalid credentials');
    await sessionManager.saveCurrentUserId(model.id);
    return UserEntity.fromModel(model);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (_online && _supabase.currentUser != null) {
      final user = _supabase.currentUser!;
      final cached = await localDataSource.getUserById(user.id);
      if (cached != null) return UserEntity.fromModel(cached);
      // Cache miss (e.g. first launch after re-install): rebuild from auth.
      final model = await _upsertLocalUserFrom(user);
      return UserEntity.fromModel(model);
    }
    final id = await sessionManager.getCurrentUserId();
    if (id == null) return null;
    final model = await localDataSource.getUserById(id);
    if (model == null) return null;
    return UserEntity.fromModel(model);
  }

  @override
  Future<void> logout() async {
    if (_online) {
      await _supabase.auth.signOut();
    }
    await sessionManager.clearSession();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final existing = await localDataSource.getUserById(user.id);
    if (existing == null) throw Exception('User not found');

    if (_online && _supabase.currentUser?.id == user.id) {
      // Push name/phone changes into auth.users metadata so other devices
      // see them on next session refresh.
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': user.name,
            if (user.phone != null) 'phone': user.phone,
          },
        ),
      );
    }

    final updated = UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      country: user.country,
      language: user.language,
      theme: user.theme,
      notificationsEnabled: user.notificationsEnabled,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    await localDataSource.updateUser(updated);
    final reloaded = await localDataSource.getUserById(user.id);
    if (reloaded == null) throw Exception('Failed to reload updated user');
    return UserEntity.fromModel(reloaded);
  }

  /// Mirror a Supabase auth.User into the local `users` table so the rest of
  /// the app can read profile data synchronously from SQLite.
  Future<UserModel> _upsertLocalUserFrom(
    User user, {
    String? nameOverride,
    String? phoneOverride,
  }) async {
    final existing = await localDataSource.getUserById(user.id);
    final meta = user.userMetadata ?? const {};
    final now = DateTime.now();
    final model = UserModel(
      id: user.id,
      email: user.email ?? existing?.email ?? '',
      name: nameOverride ??
          (meta['name'] as String?) ??
          existing?.name ??
          (user.email?.split('@').first ?? 'User'),
      phone: phoneOverride ?? (meta['phone'] as String?) ?? existing?.phone,
      country: existing?.country,
      language: existing?.language,
      theme: existing?.theme,
      notificationsEnabled: existing?.notificationsEnabled ?? true,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    if (existing == null) {
      await localDataSource.createUserMirror(model);
    } else {
      await localDataSource.updateUser(model);
    }
    return model;
  }

  String _uuid() {
    // Mirror of uuid package's v4 without taking on the import here.
    final now = DateTime.now().microsecondsSinceEpoch;
    final r = now ^ identityHashCode(this);
    return '${(r ^ now).toRadixString(16).padLeft(8, '0')}-'
        '${(now >> 16 & 0xffff).toRadixString(16).padLeft(4, '0')}-'
        '4${(now >> 32 & 0xfff).toRadixString(16).padLeft(3, '0')}-'
        '${(8 | (r >> 8 & 0x3)).toRadixString(16)}'
        '${(r >> 4 & 0xfff).toRadixString(16).padLeft(3, '0')}-'
        '${(r & 0xffffffffffff).toRadixString(16).padLeft(12, '0')}';
  }
}
