import 'package:gestanea/core/database/models/user_model.dart';
import 'package:gestanea/core/services/connectivity_service.dart';
import 'package:gestanea/core/services/profile_picture_service.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/core/utils/error_mapper.dart';
import 'package:gestanea/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gestanea/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:gestanea/features/auth/data/models/auth_repo.dart';
import 'package:gestanea/features/auth/data/models/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final SessionManager sessionManager;
  final ConnectivityService connectivityService;

  // Store password temporarily for setting after OTP verification
  String? _pendingPassword;
  void _log(String msg) => print('[AuthRepo] $msg');

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.sessionManager,
    required this.connectivityService,
  });

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _ensureOnline();

    try {
      _log('signUp start email=$email name=$name phone=$phone');
      _pendingPassword = password;

      // FIX 1: Sanitize phone. If it's an empty string, send null.
      // Supabase throws "Already registered" if multiple users have the same empty string or placeholder phone.
      final validPhone = (phone != null && phone.trim().isNotEmpty)
          ? phone.trim()
          : null;

      await remoteDataSource.signUpWithOtp(
        email: email,
        password: password,
        name: name,
        phone: validPhone,
      );

      // Return a temporary entity (Supabase usually returns void/session on signUp depending on config)
      _log('signUp OTP requested for $email; returning temp entity');
      return UserEntity(
        id: '',
        email: email,
        name: name,
        phone: validPhone,
        notificationsEnabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      // FIX 2: Strict check for the "User already registered" error
      // This enables Requirement #1 (Redirect if exists)
      if (e.message.toLowerCase().contains('already registered')) {
        // Throw a specific key your UI/Bloc can catch to trigger navigation
        throw Exception('account_exists');
      }

      // Handle other Auth errors
      throw Exception(AuthErrorMapper.mapError(e.message));
    } catch (e) {
      // Handle unexpected errors
      throw Exception(AuthErrorMapper.mapError(e.toString()));
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    _ensureOnline();
    try {
      await remoteDataSource.sendOtp(email);
    } on AuthException catch (e) {
      throw Exception(AuthErrorMapper.mapError(e.message));
    } catch (e) {
      // Map connectivity errors to localized message
      if (e.toString().contains('No internet connection')) {
        throw Exception('noInternetConnection');
      }
      throw Exception(AuthErrorMapper.mapError(e));
    }
  }

  @override
  Future<UserEntity> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    _ensureOnline();

    try {
      _log('verifyOtp start email=$email');
      // Verify OTP and set password if we have a pending password from signup.
      final supabaseUser = _pendingPassword != null
          ? await remoteDataSource.verifyOtpAndSetPassword(
              email: email,
              token: otpCode,
              password: _pendingPassword!,
            )
          : await remoteDataSource.verifyOtp(email: email, token: otpCode);

      // Get or create user profile from Supabase
      Map<String, dynamic>? profile;
      try {
        profile = await remoteDataSource.getUserProfile(supabaseUser.id);
      } catch (e) {
        // Profile might not exist yet, that's okay
        print(
          'Note: User profile not found in Supabase, will create locally: $e',
        );
      }

      // Convert Supabase user to UserEntity
      final userEntity = _userFromSupabase(supabaseUser, profile: profile);

      // Persist user locally in sqflite database
      await _persistUserLocally(userEntity);

      // Save session
      await sessionManager.saveCurrentUserId(supabaseUser.id);
      _pendingPassword = null; // Clear it

      _log('verifyOtp success email=$email userId=${supabaseUser.id}');
      return userEntity;
    } on AuthException catch (e) {
      throw Exception(AuthErrorMapper.mapError(e.message));
    } catch (e) {
      // Map connectivity errors to localized message
      if (e.toString().contains('No internet connection')) {
        throw Exception('noInternetConnection');
      }
      throw Exception(AuthErrorMapper.mapError(e));
    }
  }

  /// Persist authenticated user locally in sqflite database
  Future<void> _persistUserLocally(UserEntity userEntity) async {
    try {
      // Check if user already exists locally
      final existingUser = await localDataSource.getUserById(userEntity.id);

      final userModel = UserModel(
        id: userEntity.id,
        email: userEntity.email,
        name: userEntity.name,
        phone: userEntity.phone,
        country: userEntity.country,
        language: userEntity.language,
        theme: userEntity.theme,
        notificationsEnabled: userEntity.notificationsEnabled,
        onboardingCompleted: false, // Set to false as per requirements
        createdAt: userEntity.createdAt,
        updatedAt: userEntity.updatedAt,
      );

      if (existingUser != null) {
        // Update existing user
        await localDataSource.updateUser(userModel);
      } else {
        // Create new user
        await localDataSource.createUser(userModel);
      }
    } catch (e) {
      // Log error but don't fail authentication if local persistence fails
      print('Warning: Failed to persist user locally: $e');
      // Continue with authentication even if local persistence fails
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    _ensureOnline();

    try {
      _log('login start email=$email');
      final supabaseUser = await remoteDataSource.signInWithPassword(
        email: email,
        password: password,
      );

      final profile = await remoteDataSource.getUserProfile(supabaseUser.id);
      await sessionManager.saveCurrentUserId(supabaseUser.id);

      _log('login success email=$email userId=${supabaseUser.id}');
      return _userFromSupabase(supabaseUser, profile: profile);
    } on AuthException catch (e) {
      throw Exception(AuthErrorMapper.mapError(e.message));
    } catch (e) {
      throw Exception(AuthErrorMapper.mapError(e));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    _log('getCurrentUser found=${user != null}');
    if (user == null) return null;

    final profile = await remoteDataSource.getUserProfile(user.id);
    return _userFromSupabase(user, profile: profile);
  }

  @override
  Future<void> logout() async {
    _log('logout start');
    await remoteDataSource.signOut();
    await sessionManager.clearSession();
    // Note: We keep remembered credentials even after logout
    // They will only be cleared if user unchecks "Remember Me" or explicitly clears them
    _pendingPassword = null;
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    _ensureOnline();
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
    } on AuthException catch (e) {
      throw Exception(AuthErrorMapper.mapError(e.message));
    } catch (e) {
      throw Exception(AuthErrorMapper.mapError(e));
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _ensureOnline();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Update password on Supabase (verifies current password internally)
      await remoteDataSource.updatePassword(
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      // Update local database password hash
      await localDataSource.updatePassword(
        userId: user.id,
        newPassword: newPassword,
      );

      _log('changePassword: Password changed successfully');
    } on AuthException catch (e) {
      throw Exception(AuthErrorMapper.mapError(e.message));
    } catch (e) {
      throw Exception(AuthErrorMapper.mapError(e));
    }
  }

  @override
  Future<UserEntity> completeOnboarding({
    required String name,
    String? phone,
    String? country,
    String? language,
  }) async {
    _ensureOnline();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final profile = await remoteDataSource.upsertUserProfile(
      id: user.id,
      email: user.email ?? '',
      name: name,
      phone: phone,
      country: country,
      language: language,
      notificationsEnabled: true,
    );

    final userEntity = _userFromSupabase(user, profile: profile);

    // Update local database: mark onboarding as completed
    try {
      final userModel = UserModel(
        id: userEntity.id,
        email: userEntity.email,
        name: userEntity.name,
        phone: userEntity.phone,
        country: userEntity.country,
        language: userEntity.language,
        theme: userEntity.theme,
        notificationsEnabled: userEntity.notificationsEnabled,
        onboardingCompleted: true, // Mark onboarding as completed
        createdAt: userEntity.createdAt,
        updatedAt: DateTime.now(),
      );
      await localDataSource.updateUser(userModel);
    } catch (e) {
      // Log error but don't fail onboarding if local update fails
      print('Warning: Failed to update onboarding status locally: $e');
    }

    return userEntity;
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    _ensureOnline();

    final profile = await remoteDataSource.upsertUserProfile(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      country: user.country,
      language: user.language,
      theme: user.theme,
      notificationsEnabled: user.notificationsEnabled,
      profilePictureUrl: user.profilePictureUrl,
    );

    // Sync profile picture if URL is provided
    if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
      try {
        final profilePictureService = ProfilePictureService();
        await profilePictureService.syncProfilePictureFromRemote(
          userId: user.id,
          remoteImageUrl: user.profilePictureUrl,
        );
      } catch (e) {
        print('Warning: Failed to sync profile picture: $e');
      }
    }

    // Update local database with the new user data
    final userModel = UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      country: user.country,
      language: user.language,
      theme: user.theme,
      notificationsEnabled: user.notificationsEnabled,
      profilePicturePath: user.profilePictureUrl, // Store URL as path for local reference
      createdAt: user.createdAt,
      updatedAt: DateTime.now(),
    );
    await localDataSource.updateUser(userModel);

    final currentUser = Supabase.instance.client.auth.currentUser!;
    return _userFromSupabase(currentUser, profile: profile);
  }

  void _ensureOnline() {
    if (!connectivityService.isOnline) {
      throw Exception('noInternetConnection');
    }
  }

  UserEntity _userFromSupabase(User user, {Map<String, dynamic>? profile}) {
    final metadata = user.userMetadata ?? <String, dynamic>{};
    final name =
        (profile?['name'] as String?) ?? (metadata['name'] as String?) ?? '';
    final phone =
        (profile?['phone'] as String?) ?? (metadata['phone'] as String?);
    final country = profile?['country'] as String?;
    final language = profile?['language'] as String?;
    final theme = profile?['theme'] as String?;
    final notif = (profile?['notifications_enabled'] ?? 1) != 0;
    final profilePictureUrl = profile?['profile_picture_url'] as String?;

    // Sync profile picture if URL exists and online
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      ProfilePictureService().syncProfilePictureFromRemote(
        userId: user.id,
        remoteImageUrl: profilePictureUrl,
      ).catchError((e) {
        print('Warning: Failed to sync profile picture on user load: $e');
      });
    }

    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      name: name.isNotEmpty ? name : (user.email?.split('@').first ?? 'User'),
      phone: phone,
      country: country,
      language: language,
      theme: theme,
      notificationsEnabled: notif,
      profilePictureUrl: profilePictureUrl,
      createdAt:
          DateTime.tryParse(profile?['created_at'] ?? user.createdAt) ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(
            profile?['updated_at'] ?? user.updatedAt ?? user.createdAt,
          ) ??
          DateTime.now(),
    );
  }
}
