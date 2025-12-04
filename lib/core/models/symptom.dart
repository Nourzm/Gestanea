class Symptom {
  final String id;
  final String userId;
  final String? pregnancyId;
  final DateTime date;
  final DateTime time;
  final String symptom;
  final int severity; // 1-5
  final String? notes;
  final DateTime createdAt;

  Symptom({
    required this.id,
    required this.userId,
    this.pregnancyId,
    required this.date,
    required this.time,
    required this.symptom,
    required this.severity,
    this.notes,
    required this.createdAt,
  });

  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      symptom: map['symptom'] as String,
      severity: map['severity'] as int,
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
      'symptom': symptom,
      'severity': severity,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
