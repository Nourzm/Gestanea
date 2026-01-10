class MeasurementModel {
  final String id;
  final String userId;
  final double?  weight; // in kg
  final int? heartRate; // in bpm
  final int? systolic; // blood pressure
  final int? diastolic; // blood pressure
  final DateTime recordedAt;
  final String? notes;
  final DateTime createdAt;

  MeasurementModel({
    required this.id,
    required this. userId,
    this.weight,
    this.heartRate,
    this.systolic,
    this.diastolic,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
  });

  // Helper getters
  String get bloodPressure => systolic != null && diastolic != null 
      ? '$systolic/$diastolic' 
      : 'N/A';

  String get weightStatus {
    if (weight == null) return 'N/A';
    return 'Normal'; // TODO: Add BMI calculation logic
  }

  String get heartRateStatus {
    if (heartRate == null) return 'N/A';
    if (heartRate! >= 60 && heartRate! <= 100) return 'Normal';
    if (heartRate! < 60) return 'Low';
    return 'High';
  }

  String get bloodPressureStatus {
    if (systolic == null || diastolic == null) return 'N/A';
    if (systolic! < 120 && diastolic! < 80) return 'Normal';
    if (systolic! < 130 && diastolic!  < 80) return 'Elevated';
    return 'High';
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'heart_rate': heartRate,
      'systolic': systolic,
      'diastolic': diastolic,
      'recorded_at': recordedAt.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory MeasurementModel.fromMap(Map<String, dynamic> map) {
    return MeasurementModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      weight: map['weight'] as double?,
      heartRate: map['heart_rate'] as int?,
      systolic: map['systolic'] as int?,
      diastolic: map['diastolic'] as int?,
      recordedAt: DateTime. parse(map['recorded_at'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  MeasurementModel copyWith({
    String? id,
    String? userId,
    double? weight,
    int? heartRate,
    int? systolic,
    int? diastolic,
    DateTime? recordedAt,
    String? notes,
    DateTime? createdAt,
  }) {
    return MeasurementModel(
      id: id ??  this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      heartRate: heartRate ??  this.heartRate,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ??  this.notes,
      createdAt: createdAt ?? this. createdAt,
    );
  }
}