class VitalModel {
  final String id;
  final String userId;
  final String vitalType;
  final double value;
  final String?  unit;
  final DateTime recordedAt;
  final String? notes;
  final DateTime createdAt;

  VitalModel({
    required this.id,
    required this.userId,
    required this.vitalType,
    required this.value,
    this.unit,
    required this. recordedAt,
    this. notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'vital_type': vitalType,
      'value': value,
      'unit': unit,
      'recorded_at': recordedAt.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VitalModel.fromMap(Map<String, dynamic> map) {
    return VitalModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      vitalType: map['vital_type'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  VitalModel copyWith({
    String?  id,
    String? userId,
    String? vitalType,
    double? value,
    String? unit,
    DateTime?  recordedAt,
    String?  notes,
    DateTime? createdAt,
  }) {
    return VitalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vitalType: vitalType ?? this.vitalType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}