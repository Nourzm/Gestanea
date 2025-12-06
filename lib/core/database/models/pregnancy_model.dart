class PregnancyModel {
  final String id;
  final String userId;
  final DateTime lmpDate;
  final DateTime dueDate;
  final int? currentWeek;
  final String? currentTrimester;
  final bool isActive;
  final String?  medicalConditions;
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
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}