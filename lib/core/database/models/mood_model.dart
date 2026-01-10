class MoodModel {
  final String id;
  final String userId;
  final String mood;
  final int? intensity;
  final String? notes;
  final DateTime recordedAt;
  final DateTime createdAt;
  final int synced;

  MoodModel({
    required this.id,
    required this.userId,
    required this.mood,
    this.intensity,
    this.notes,
    required this.recordedAt,
    required this.createdAt,
    this.synced = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'mood': mood,
      'intensity': intensity,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'synced': synced,
    };
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      mood: map['mood'] as String,
      intensity: map['intensity'] as int?,
      notes: map['notes'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      synced: (map['synced'] as int?) ?? 0,
    );
  }

  MoodModel copyWith({
    String? id,
    String? userId,
    String? mood,
    int?  intensity,
    String? notes,
    DateTime? recordedAt,
    DateTime? createdAt,
    int? synced,
  }) {
    return MoodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      intensity: intensity ?? this.intensity,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }
}