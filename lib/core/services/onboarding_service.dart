import 'package:gestanea/core/database/db_helper.dart';
import 'package:gestanea/core/database/models/user_model.dart';
import 'package:gestanea/core/database/models/pregnancy_model.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/database/models/health_profile_model.dart';
import 'package:gestanea/core/config/supabase_config.dart';
import 'package:gestanea/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// Service to handle onboarding data persistence and sync
/// Supabase-first: saves to Supabase directly, local DB as cache only
class OnboardingService {
  static final OnboardingService _instance = OnboardingService._internal();
  factory OnboardingService() => _instance;
  OnboardingService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource(DatabaseHelper.instance);
  final Uuid _uuid = const Uuid();

  /// Phase 1: Save common user info (without user_status)
  /// Saves: date_of_birth, height_cm, baseline_weight, country, phone
  Future<void> saveCommonInfo({
    required String userId,
    required DateTime dateOfBirth,
    required double heightCm,
    required double baselineWeight,
    required String country,
    String? phone,
  }) async {
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    if (supabaseUser == null) {
      throw Exception('No authenticated user');
    }

    final now = DateTime.now();
    final dobDate = dateOfBirth.toIso8601String().split('T')[0];

    // Build user data for Supabase
    final userData = {
      'id': userId,
      'email': supabaseUser.email ?? '',
      'name': supabaseUser.userMetadata?['name'] as String? ?? 
              (supabaseUser.email?.split('@').first ?? 'User'),
      'phone': phone, // Use the phone parameter from the form
      'country': country,
      'notifications_enabled': 1,
      'date_of_birth': dobDate,
      'height_cm': heightCm,
      'baseline_weight': baselineWeight,
      'updated_at': now.toIso8601String(),
    };

    // Save to Supabase FIRST (always try)
    try {
      await SupabaseConfig.client.from('users').upsert(userData);
      print('User saved to Supabase successfully');
    } catch (e) {
      print('Warning: Failed to save to Supabase: $e');
      // Continue - will cache locally as backup
    }

    // Cache locally as backup (optional)
    try {
      final db = await _dbHelper.database;
      final userResult = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      final user = UserModel(
        id: userId,
        email: supabaseUser.email ?? '',
        name: supabaseUser.userMetadata?['name'] as String? ?? 
              (supabaseUser.email?.split('@').first ?? 'User'),
        phone: phone ?? supabaseUser.phone,
        country: country,
        language: null,
        theme: null,
        notificationsEnabled: true,
        onboardingCompleted: false,
        profilePicturePath: null,
        dateOfBirth: dateOfBirth,
        heightCm: heightCm,
        baselineWeight: baselineWeight,
        userStatus: null,
        createdAt: DateTime.tryParse(supabaseUser.createdAt) ?? now,
        updatedAt: now,
      );

      if (userResult.isEmpty) {
        await _authLocalDataSource.createUser(user);
      } else {
        await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [userId]);
      }
    } catch (e) {
      print('Warning: Failed to cache locally: $e');
      // Not critical - Supabase is the source of truth
    }
  }

  /// Save user status selection
  Future<void> saveUserStatus({
    required String userId,
    required String userStatus, // 'pregnant', 'postpartum', 'baby', 'none'
  }) async {
    // Save to Supabase FIRST
    try {
      await SupabaseConfig.client.from('users').update({
        'user_status': userStatus,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      print('User status saved to Supabase successfully');
    } catch (e) {
      print('Warning: Failed to save status to Supabase: $e');
    }

    // Cache locally as backup
    try {
      final db = await _dbHelper.database;
      await db.update(
        'users',
        {
          'user_status': userStatus,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Warning: Failed to cache status locally: $e');
    }
  }

  /// Phase 2a: Save pregnancy info
  /// Due date is automatically calculated as LMP + 280 days (40 weeks) if not provided
  Future<void> savePregnancyInfo({
    required String userId,
    required DateTime lmpDate,
    DateTime? dueDate,
    required bool isFirstPregnancy,
    required bool isHighRisk,
    String? medicalConditions,
    double? initialWeight,
  }) async {
    // Calculate due date if not provided (LMP + 280 days = 40 weeks)
    final calculatedDueDate = dueDate ?? lmpDate.add(const Duration(days: 280));
    
    final now = DateTime.now();
    final pregnancyId = _uuid.v4();
    
    final pregnancyData = {
      'id': pregnancyId,
      'user_id': userId,
      'lmp_date': lmpDate.toIso8601String().split('T')[0],
      'due_date': calculatedDueDate.toIso8601String().split('T')[0],
      'is_active': true,
      'is_first_pregnancy': isFirstPregnancy,
      'is_high_risk': isHighRisk,
      'medical_conditions': medicalConditions,
      'updated_at': now.toIso8601String(),
    };

    // Save to Supabase FIRST
    try {
      await SupabaseConfig.client.from('pregnancies').upsert(pregnancyData);
      print('Pregnancy saved to Supabase successfully');
    } catch (e) {
      print('Warning: Failed to save pregnancy to Supabase: $e');
    }

    // Cache locally as backup
    try {
      final db = await _dbHelper.database;
      final pregnancy = PregnancyModel(
        id: pregnancyId,
        userId: userId,
        lmpDate: lmpDate,
        dueDate: calculatedDueDate,
        isActive: true,
        isFirstPregnancy: isFirstPregnancy,
        isHighRisk: isHighRisk,
        medicalConditions: medicalConditions,
        createdAt: now,
        updatedAt: now,
      );
      
      await db.insert('pregnancies', pregnancy.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Warning: Failed to cache pregnancy locally: $e');
    }
  }

  /// Phase 2b: Save baby/postpartum info
  Future<void> saveBabyInfo({
    required String userId,
    required String babyName,
    required DateTime dateOfBirth,
    required String gender,
    double? birthWeight,
    double? birthHeight,
  }) async {
    final now = DateTime.now();
    final babyId = _uuid.v4();
    
    final babyData = {
      'id': babyId,
      'user_id': userId,
      'name': babyName,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
      'birth_weight': birthWeight,
      'birth_height': birthHeight,
      'theme_color': gender == 'girl' ? '#FFB6D9' : '#87CEEB',
      'is_active': true,
      'updated_at': now.toIso8601String(),
    };

    // Save to Supabase FIRST
    try {
      await SupabaseConfig.client.from('babies').upsert(babyData);
      print('Baby saved to Supabase successfully');
    } catch (e) {
      print('Warning: Failed to save baby to Supabase: $e');
    }

    // Cache locally as backup
    try {
      final db = await _dbHelper.database;
      final baby = BabyModel(
        id: babyId,
        userId: userId,
        name: babyName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        birthWeight: birthWeight,
        birthHeight: birthHeight,
        themeColor: gender == 'girl' ? '#FFB6D9' : '#87CEEB',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      
      await db.insert('babies', baby.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Warning: Failed to cache baby locally: $e');
    }
  }

  /// Phase 3: Save health profile (optional)
  Future<void> saveHealthProfile({
    required String userId,
    String? bloodType,
    String? chronicConditions,
    String? allergies,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    final now = DateTime.now();
    final healthId = _uuid.v4();
    
    final healthData = {
      'id': healthId,
      'user_id': userId,
      'blood_type': bloodType,
      'chronic_conditions': chronicConditions,
      'allergies': allergies,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'updated_at': now.toIso8601String(),
    };

    // Save to Supabase FIRST
    try {
      await SupabaseConfig.client.from('user_health_profile').upsert(healthData);
      print('Health profile saved to Supabase successfully');
    } catch (e) {
      print('Warning: Failed to save health profile to Supabase: $e');
    }

    // Cache locally as backup
    try {
      final db = await _dbHelper.database;
      final existing = await db.query(
        'user_health_profile',
        where: 'user_id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      
      final healthProfile = HealthProfileModel(
        id: existing.isNotEmpty ? (existing.first['id'] as String) : healthId,
        userId: userId,
        bloodType: bloodType,
        chronicConditions: chronicConditions,
        allergies: allergies,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        createdAt: existing.isNotEmpty
            ? DateTime.parse(existing.first['created_at'] as String)
            : now,
        updatedAt: now,
      );
      
      if (existing.isNotEmpty) {
        await db.update(
          'user_health_profile',
          healthProfile.toMap(),
          where: 'user_id = ?',
          whereArgs: [userId],
        );
      } else {
        await db.insert('user_health_profile', healthProfile.toMap());
      }
    } catch (e) {
      print('Warning: Failed to cache health profile locally: $e');
    }
  }

  /// Phase 4: Complete onboarding
  Future<void> completeOnboarding(String userId) async {
    // Save to Supabase FIRST
    try {
      await SupabaseConfig.client
          .from('users')
          .update({'onboarding_completed': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', userId);
      print('Onboarding completion saved to Supabase successfully');
    } catch (e) {
      print('Warning: Failed to save onboarding completion to Supabase: $e');
    }

    // Cache locally as backup
    try {
      final db = await _dbHelper.database;
      await db.update(
        'users',
        {
          'onboarding_completed': 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Warning: Failed to cache onboarding completion locally: $e');
    }
  }
}
