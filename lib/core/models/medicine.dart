class Medicine {
  final String id;
  final String userId;
  final String? pregnancyId;
  final String? babyId;
  final String name;
  final String dosage;
  final String frequency;
  final int timesPerDay;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;

  Medicine({
    required this.id,
    required this.userId,
    this.pregnancyId,
    this.babyId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timesPerDay,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.notes,
    required this.createdAt,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      babyId: map['baby_id'] as String?,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      frequency: map['frequency'] as String,
      timesPerDay: map['times_per_day'] as int,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date'] as String) : null,
      isActive: (map['is_active'] as int) == 1,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pregnancy_id': pregnancyId,
      'baby_id': babyId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times_per_day': timesPerDay,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
