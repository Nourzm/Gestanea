class PregnancyModel {
  final String id;
  final String userId;
  final DateTime lmpDate;
  final DateTime dueDate;
  final int? currentWeek;
  final String? currentTrimester;
  final bool isActive;
  final String? medicalConditions;
  final double? prePregnancyWeight; // kg
  final double? heightCm;
  final DateTime createdAt;
  final DateTime updatedAt;

  PregnancyModel({
    required this.id,
    required this.userId,
    required this.lmpDate,
    required this.dueDate,
    this.currentWeek,
    this.currentTrimester,
    this.isActive = true,
    this.medicalConditions,
    this.prePregnancyWeight,
    this.heightCm,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'lmp_date': lmpDate.toIso8601String().split('T')[0],
      'due_date': dueDate.toIso8601String().split('T')[0],
      'current_week': currentWeek,
      'current_trimester': currentTrimester,
      'is_active': isActive ? 1 : 0,
      'medical_conditions': medicalConditions,
      'pre_pregnancy_weight': prePregnancyWeight,
      'height_cm': heightCm,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PregnancyModel.fromMap(Map<String, dynamic> map) {
    return PregnancyModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      lmpDate: DateTime.parse(map['lmp_date'] as String),
      dueDate: DateTime.parse(map['due_date'] as String),
      currentWeek: map['current_week'] as int?,
      currentTrimester: map['current_trimester'] as String?,
      isActive: (map['is_active'] as int) == 1,
      medicalConditions: map['medical_conditions'] as String?,
      prePregnancyWeight: (map['pre_pregnancy_weight'] as num?)?.toDouble(),
      heightCm: (map['height_cm'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  PregnancyModel copyWith({
    double? prePregnancyWeight,
    double? heightCm,
    DateTime? updatedAt,
  }) {
    return PregnancyModel(
      id: id,
      userId: userId,
      lmpDate: lmpDate,
      dueDate: dueDate,
      currentWeek: currentWeek,
      currentTrimester: currentTrimester,
      isActive: isActive,
      medicalConditions: medicalConditions,
      prePregnancyWeight: prePregnancyWeight ?? this.prePregnancyWeight,
      heightCm: heightCm ?? this.heightCm,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
