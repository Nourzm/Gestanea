class Mood {
  final String id;
  final String userId;
  final String? pregnancyId;
  final DateTime date;
  final DateTime time;
  final String mood; // 'happy', 'anxious', 'tired', 'stressed', etc.
  final int intensity; // 1-5
  final String? notes;
  final DateTime createdAt;

  Mood({
    required this.id,
    required this.userId,
    this.pregnancyId,
    required this.date,
    required this.time,
    required this.mood,
    required this.intensity,
    this.notes,
    required this.createdAt,
  });

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      pregnancyId: map['pregnancy_id'] as String?,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      mood: map['mood'] as String,
      intensity: map['intensity'] as int,
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
      'mood': mood,
      'intensity': intensity,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
