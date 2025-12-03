class FeedingLogModel {
  final String id;
  final String babyId;
  final String feedingType;
  final int? durationMinutes;
  final double? amountMl;
  final String? breastSide;
  final DateTime loggedAt;
  final String? notes;
  final DateTime createdAt;

  FeedingLogModel({
    required this.id,
    required this.babyId,
    required this.feedingType,
    this.durationMinutes,
    this.amountMl,
    this. breastSide,
    required this.loggedAt,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baby_id': babyId,
      'feeding_type': feedingType,
      'duration_minutes': durationMinutes,
      'amount_ml': amountMl,
      'breast_side': breastSide,
      'logged_at': loggedAt.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FeedingLogModel.fromMap(Map<String, dynamic> map) {
    return FeedingLogModel(
      id: map['id'] as String,
      babyId: map['baby_id'] as String,
      feedingType: map['feeding_type'] as String,
      durationMinutes: map['duration_minutes'] as int?,
      amountMl: map['amount_ml'] as double?,
      breastSide: map['breast_side'] as String?,
      loggedAt: DateTime.parse(map['logged_at'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  FeedingLogModel copyWith({
    String? id,
    String? babyId,
    String? feedingType,
    int? durationMinutes,
    double? amountMl,
    String? breastSide,
    DateTime? loggedAt,
    String? notes,
    DateTime? createdAt,
  }) {
    return FeedingLogModel(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      feedingType: feedingType ?? this.feedingType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      amountMl: amountMl ?? this.amountMl,
      breastSide: breastSide ?? this.breastSide,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}