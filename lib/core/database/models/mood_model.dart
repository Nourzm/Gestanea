/// A logged mood entry.
///
/// [mood] is a stable canonical key (e.g. `very_happy`) — never a localized
/// label — so stored data is language-independent. The UI maps it to an emoji
/// and a translated label at display time.
class MoodModel {
  final String id;
  final String userId;
  final String mood; // canonical key
  final int? energyLevel; // 1..5
  final int? sleepQuality; // 1..5
  final String? notes;
  final DateTime recordedAt;
  final DateTime createdAt;

  MoodModel({
    required this.id,
    required this.userId,
    required this.mood,
    this.energyLevel,
    this.sleepQuality,
    this.notes,
    required this.recordedAt,
    required this.createdAt,
  });

  /// Canonical mood keys, most positive first (matches the selector order).
  static const List<String> keys = [
    'very_happy',
    'happy',
    'neutral',
    'sad',
    'very_sad',
  ];

  static const Map<String, String> emojis = {
    'very_happy': '😊',
    'happy': '🙂',
    'neutral': '😐',
    'sad': '😔',
    'very_sad': '😢',
  };

  String get emoji => emojis[mood] ?? '🙂';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'mood': mood,
      // intensity mirrors energy_level for the legacy column.
      'intensity': energyLevel,
      'energy_level': energyLevel,
      'sleep_quality': sleepQuality,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      mood: map['mood'] as String,
      energyLevel: (map['energy_level'] ?? map['intensity']) as int?,
      sleepQuality: map['sleep_quality'] as int?,
      notes: map['notes'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  MoodModel copyWith({
    String? id,
    String? userId,
    String? mood,
    int? energyLevel,
    int? sleepQuality,
    String? notes,
    DateTime? recordedAt,
    DateTime? createdAt,
  }) {
    return MoodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
