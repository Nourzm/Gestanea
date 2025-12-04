class Pregnancy {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isActive;
  final String? medicalConditions;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pregnancy({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.dueDate,
    required this.isActive,
    this.medicalConditions,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pregnancy.fromMap(Map<String, dynamic> map) {
    return Pregnancy(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      dueDate: DateTime.parse(map['due_date'] as String),
      isActive: (map['is_active'] as int) == 1,
      medicalConditions: map['medical_conditions'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'medical_conditions': medicalConditions,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int get currentWeek {
    final now = DateTime.now();
    final daysSinceStart = now.difference(startDate).inDays;
    return (daysSinceStart / 7).floor() + 1;
  }

  int get weeksRemaining {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;
    return (daysUntilDue / 7).ceil();
  }

  Pregnancy copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? dueDate,
    bool? isActive,
    String? medicalConditions,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pregnancy(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      isActive: isActive ?? this.isActive,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
