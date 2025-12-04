class Milestone {
  final String id;
  final String babyId;
  final String title;
  final String? description;
  final String category;
  final int? expectedAgeMonths;
  final bool achieved;
  final DateTime? achievedDate;
  final String? notes;
  final DateTime createdAt;

  Milestone({
    required this.id,
    required this.babyId,
    required this.title,
    this.description,
    required this.category,
    this.expectedAgeMonths,
    required this.achieved,
    this.achievedDate,
    this.notes,
    required this.createdAt,
  });

  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
      id: map['id'] as String,
      babyId: map['baby_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      expectedAgeMonths: map['expected_age_months'] as int?,
      achieved: (map['achieved'] as int) == 1,
      achievedDate: map['achieved_date'] != null ? DateTime.parse(map['achieved_date'] as String) : null,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baby_id': babyId,
      'title': title,
      'description': description,
      'category': category,
      'expected_age_months': expectedAgeMonths,
      'achieved': achieved ? 1 : 0,
      'achieved_date': achievedDate?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
