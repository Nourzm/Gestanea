class MilestoneModel {
  final String id;
  final String babyId;
  final String milestoneName;
  final int? expectedAgeMonths;
  final DateTime? achievedDate;
  final String? notes;
  final DateTime createdAt;

  MilestoneModel({
    required this.id,
    required this.babyId,
    required this.milestoneName,
    this.expectedAgeMonths,
    this.achievedDate,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baby_id': babyId,
      'milestone_name': milestoneName,
      'expected_age_months': expectedAgeMonths,
      'achieved_date': achievedDate?.toIso8601String().split('T')[0],
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      id: map['id'] as String,
      babyId: map['baby_id'] as String,
      milestoneName: map['milestone_name'] as String,
      expectedAgeMonths: map['expected_age_months'] as int?,
      achievedDate: map['achieved_date'] != null
          ? DateTime.parse(map['achieved_date'] as String)
          : null,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  MilestoneModel copyWith({
    String? id,
    String? babyId,
    String? milestoneName,
    int? expectedAgeMonths,
    DateTime? achievedDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      milestoneName: milestoneName ?? this.milestoneName,
      expectedAgeMonths: expectedAgeMonths ?? this.expectedAgeMonths,
      achievedDate: achievedDate ?? this.achievedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
