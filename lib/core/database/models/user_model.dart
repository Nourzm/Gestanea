class UserModel {
  final String id;
  final String email;
  final String name;
  final String?  phone;
  final String? country;
  final String? language;
  final String? theme;
  final bool notificationsEnabled;
  final bool onboardingCompleted;
  final String? profilePicturePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this. country,
    this.language,
    this.theme,
    this.notificationsEnabled = true,
    this.onboardingCompleted = false,
    this.profilePicturePath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'country': country,
      'language': language,
      'theme': theme,
      'notifications_enabled': notificationsEnabled ?  1 : 0,
      'onboarding_completed': onboardingCompleted ? 1 : 0,
      'profile_picture_path': profilePicturePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      country: map['country'] as String?,
      language: map['language'] as String?,
      theme: map['theme'] as String?,
      notificationsEnabled: (map['notifications_enabled'] as int? ?? 1) == 1,
      onboardingCompleted: (map['onboarding_completed'] as int? ?? 0) == 1,
      profilePicturePath: map['profile_picture_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime. parse(map['updated_at'] as String),
    );
  }

  UserModel copyWith({
    String?  id,
    String? email,
    String? name,
    String? phone,
    String?  country,
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? onboardingCompleted,
    String? profilePicturePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}