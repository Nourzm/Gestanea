class KickCountModel {
  final String id;
  final String userId;
  final int kickCount;
  final int?  durationMinutes;
  final DateTime recordedAt;
  final String? notes;
  final DateTime createdAt;

  KickCountModel({
    required this.id,
    required this.userId,
    required this.kickCount,
    this. durationMinutes,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'kick_count': kickCount,
      'duration_minutes': durationMinutes,
      'recorded_at': recordedAt.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory KickCountModel.fromMap(Map<String, dynamic> map) {
    return KickCountModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      kickCount: map['kick_count'] as int,
      durationMinutes: map['duration_minutes'] as int?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  KickCountModel copyWith({
    String? id,
    String?  userId,
    int? kickCount,
    int? durationMinutes,
    DateTime? recordedAt,
    String? notes,
    DateTime? createdAt,
  }) {
    return KickCountModel(
      id: id ??  this.id,
      userId: userId ?? this.userId,
      kickCount: kickCount ?? this. kickCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      recordedAt: recordedAt ??  this.recordedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}