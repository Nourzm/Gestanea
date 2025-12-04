class KickCount {
  final String id;
  final String pregnancyId;
  final DateTime date;
  final DateTime startTime;
  final DateTime? endTime;
  final int count;
  final int? durationMinutes;
  final String? notes;
  final DateTime createdAt;

  KickCount({
    required this.id,
    required this.pregnancyId,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.count,
    this.durationMinutes,
    this.notes,
    required this.createdAt,
  });

  factory KickCount.fromMap(Map<String, dynamic> map) {
    return KickCount(
      id: map['id'] as String,
      pregnancyId: map['pregnancy_id'] as String,
      date: DateTime.parse(map['date'] as String),
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time'] as String) : null,
      count: map['count'] as int,
      durationMinutes: map['duration_minutes'] as int?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pregnancy_id': pregnancyId,
      'date': date.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'count': count,
      'duration_minutes': durationMinutes,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
