class Vital {
  final String id;
  final String userId;
  final String? pregnancyId;
  final DateTime date;
  final DateTime time;
  final String type; // 'blood_pressure', 'heart_rate', 'temperature', 'weight', 'glucose'
  final double value;
  final String unit;
  final String? notes;
  final DateTime createdAt;

  Vital({
    required this.id,
    required this.userId,
    this.pregnancyId,
    required this.date,
    required this.time,
    required this.type,
    required this.value,
    required this.unit,
    this.notes,
    required this.createdAt,
  });

  factory Vital.fromMap(Map<String, dynamic> map) {
    return Vital(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      type: map['type'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'pregnancy_id': pregnancyId,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'type': type,
      'value': value,
      'unit': unit,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
