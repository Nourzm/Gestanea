class FeedingLog {
  final String id;
  final String babyId;
  final DateTime date;
  final DateTime time;
  final String type; // 'breastfeeding', 'bottle', 'solid'
  final int? durationMinutes;
  final double? amountMl;
  final String? breastSide; // 'left', 'right', 'both'
  final String? notes;
  final DateTime createdAt;

  FeedingLog({
    required this.id,
    required this.babyId,
    required this.date,
    required this.time,
    required this.type,
    this.durationMinutes,
    this.amountMl,
    this.breastSide,
    this.notes,
    required this.createdAt,
  });

  factory FeedingLog.fromMap(Map<String, dynamic> map) {
    return FeedingLog(
      id: map['id'] as String,
      babyId: map['baby_id'] as String,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      type: map['type'] as String,
      durationMinutes: map['duration_minutes'] as int?,
      amountMl: map['amount_ml'] != null ? (map['amount_ml'] as num).toDouble() : null,
      breastSide: map['breast_side'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baby_id': babyId,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'type': type,
      'duration_minutes': durationMinutes,
      'amount_ml': amountMl,
      'breast_side': breastSide,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
