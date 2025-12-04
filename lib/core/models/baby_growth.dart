class BabyGrowth {
  final String id;
  final String babyId;
  final DateTime date;
  final double weight;
  final double height;
  final double? headCircumference;
  final String? notes;
  final DateTime createdAt;

  BabyGrowth({
    required this.id,
    required this.babyId,
    required this.date,
    required this.weight,
    required this.height,
    this.headCircumference,
    this.notes,
    required this.createdAt,
  });

  factory BabyGrowth.fromMap(Map<String, dynamic> map) {
    return BabyGrowth(
      id: map['id'] as String,
      babyId: map['baby_id'] as String,
      date: DateTime.parse(map['date'] as String),
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      headCircumference: map['head_circumference'] != null ? (map['head_circumference'] as num).toDouble() : null,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baby_id': babyId,
      'date': date.toIso8601String(),
      'weight': weight,
      'height': height,
      'head_circumference': headCircumference,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
