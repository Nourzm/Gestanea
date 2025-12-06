class BabyModel {
  final String id;
  final String userId;
  final String name;
  final String?  gender;
  final DateTime dateOfBirth;
  final double?  birthWeight;
  final double? birthHeight;
  final String? themeColor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  BabyModel({
    required this.id,
    required this.userId,
    required this.name,
    this.gender,
    required this.dateOfBirth,
    this.birthWeight,
    this.birthHeight,
    this.themeColor,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String(). split('T')[0],
      'birth_weight': birthWeight,
      'birth_height': birthHeight,
      'theme_color': themeColor,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BabyModel. fromMap(Map<String, dynamic> map) {
    return BabyModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      gender: map['gender'] as String?,
      dateOfBirth: DateTime.parse(map['date_of_birth'] as String),
      birthWeight: map['birth_weight'] as double?,
      birthHeight: map['birth_height'] as double?,
      themeColor: map['theme_color'] as String?,
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}