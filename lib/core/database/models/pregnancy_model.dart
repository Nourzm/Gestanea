class PregnancyModel {
  final String id;
  final String userId;
  final DateTime lmpDate;
  final DateTime dueDate;
  final int? currentWeek;
  final String? currentTrimester;
  final bool isActive;
  final String?  medicalConditions;
  final bool isFirstPregnancy;
  final bool isHighRisk;
  final DateTime createdAt;
  final DateTime updatedAt;

  PregnancyModel({
    required this.id,
    required this. userId,
    required this.lmpDate,
    required this. dueDate,
    this. currentWeek,
    this. currentTrimester,
    this.isActive = true,
    this.medicalConditions,
    this.isFirstPregnancy = false,
    this.isHighRisk = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'lmp_date': lmpDate. toIso8601String(). split('T')[0],
      'due_date': dueDate.toIso8601String().split('T')[0],
      'current_week': currentWeek,
      'current_trimester': currentTrimester,
      'is_active': isActive ? 1 : 0,
      'medical_conditions': medicalConditions,
      'is_first_pregnancy': isFirstPregnancy ? 1 : 0,
      'is_high_risk': isHighRisk ? 1 : 0,
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
      isActive: (map['is_active'] as int? ?? 1) == 1,
      medicalConditions: map['medical_conditions'] as String?,
      isFirstPregnancy: (map['is_first_pregnancy'] as int? ?? 0) == 1,
      isHighRisk: (map['is_high_risk'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}