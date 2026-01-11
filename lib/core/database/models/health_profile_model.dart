/// Model for user health profile information
class HealthProfileModel {
  final String id;
  final String userId;
  final String? bloodType;
  final String? chronicConditions;
  final String? allergies;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  HealthProfileModel({
    required this.id,
    required this.userId,
    this.bloodType,
    this.chronicConditions,
    this.allergies,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'blood_type': bloodType,
      'chronic_conditions': chronicConditions,
      'allergies': allergies,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory HealthProfileModel.fromMap(Map<String, dynamic> map) {
    return HealthProfileModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      bloodType: map['blood_type'] as String?,
      chronicConditions: map['chronic_conditions'] as String?,
      allergies: map['allergies'] as String?,
      emergencyContactName: map['emergency_contact_name'] as String?,
      emergencyContactPhone: map['emergency_contact_phone'] as String?,
      createdAt: DateTime.parse(
        map['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  HealthProfileModel copyWith({
    String? id,
    String? userId,
    String? bloodType,
    String? chronicConditions,
    String? allergies,
    String? emergencyContactName,
    String? emergencyContactPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bloodType: bloodType ?? this.bloodType,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      allergies: allergies ?? this.allergies,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
