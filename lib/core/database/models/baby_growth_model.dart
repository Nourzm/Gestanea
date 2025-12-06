class BabyGrowthModel {
  final String id;
  final String babyId;
  final DateTime recordedDate;
  final double? weight;
  final double? height;
  final int? weightPercentile;
  final int? heightPercentile;
  final String? growthStatus;
  final String? notes;
  final DateTime createdAt;

  BabyGrowthModel({
    required this.id,
    required this.babyId,
    required this.recordedDate,
    this.weight,
    this.height,
    this.weightPercentile,
    this.heightPercentile,
    this.growthStatus,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baby_id': babyId,
      'recorded_date': recordedDate.toIso8601String(). split('T')[0],
      'weight': weight,
      'height': height,
      'weight_percentile': weightPercentile,
      'height_percentile': heightPercentile,
      'growth_status': growthStatus,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BabyGrowthModel.fromMap(Map<String, dynamic> map) {
    return BabyGrowthModel(
      id: map['id'] as String,
      babyId: map['baby_id'] as String,
      recordedDate: DateTime.parse(map['recorded_date'] as String),
      weight: map['weight'] as double?,
      height: map['height'] as double?,
      weightPercentile: map['weight_percentile'] as int?,
      heightPercentile: map['height_percentile'] as int?,
      growthStatus: map['growth_status'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  BabyGrowthModel copyWith({
    String? id,
    String? babyId,
    DateTime? recordedDate,
    double? weight,
    double? height,
    int? weightPercentile,
    int? heightPercentile,
    String? growthStatus,
    String? notes,
    DateTime? createdAt,
  }) {
    return BabyGrowthModel(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      recordedDate: recordedDate ?? this.recordedDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      weightPercentile: weightPercentile ?? this.weightPercentile,
      heightPercentile: heightPercentile ?? this.heightPercentile,
      growthStatus: growthStatus ?? this.growthStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}