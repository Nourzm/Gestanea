import 'dart:convert';

class MedicineModel {
  final String id;
  final String? userId;
  final String? babyId;
  final String medicineName;
  final String dosage;
  final String? type;
  final String frequencyType;
  final int? frequencyValue;
  final List<String>? scheduledTimes;
  final DateTime startDate;
  final DateTime? endDate;
  final int? maxDoses;
  final String? medicineImageUrl;
  final bool isActive;
  final DateTime createdAt;

  MedicineModel({
    required this.id,
    this.userId,
    this.babyId,
    required this.medicineName,
    required this.dosage,
    this.type,
    required this.frequencyType,
    this.frequencyValue,
    this.scheduledTimes,
    required this.startDate,
    this.endDate,
    this.maxDoses,
    this.medicineImageUrl,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'baby_id': babyId,
      'medicine_name': medicineName,
      'dosage': dosage,
      'type': type,
      'frequency_type': frequencyType,
      'frequency_value': frequencyValue,
      'scheduled_times': scheduledTimes != null
          ? jsonEncode(scheduledTimes)
          : null,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'max_doses': maxDoses,
      'medicine_image_url': medicineImageUrl,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'] as String,
      userId: map['user_id'] as String?,
      babyId: map['baby_id'] as String?,
      medicineName: map['medicine_name'] as String,
      dosage: map['dosage'] as String,
      type: map['type'] as String?,
      frequencyType: map['frequency_type'] as String,
      frequencyValue: map['frequency_value'] as int?,
      scheduledTimes: map['scheduled_times'] != null
          ? List<String>.from(jsonDecode(map['scheduled_times'] as String))
          : null,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      maxDoses: map['max_doses'] as int?,
      medicineImageUrl: map['medicine_image_url'] as String?,
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  MedicineModel copyWith({
    String? id,
    String? userId,
    String? babyId,
    String? medicineName,
    String? dosage,
    String? type,
    String? frequencyType,
    int? frequencyValue,
    List<String>? scheduledTimes,
    DateTime? startDate,
    DateTime? endDate,
    int? maxDoses,
    String? medicineImageUrl,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      babyId: babyId ?? this.babyId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      type: type ?? this.type,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyValue: frequencyValue ?? this.frequencyValue,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxDoses: maxDoses ?? this.maxDoses,
      medicineImageUrl: medicineImageUrl ?? this.medicineImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
