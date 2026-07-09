// lib/features/baby/domain/entities/baby_growth.dart
class BabyGrowth {
  final String id;
  final String babyId;
  final DateTime date;
  final double weight; // in kg
  final double height; // in cm
  final double? headCircumference; // in cm
  final String notes;

  const BabyGrowth({
    required this.id,
    required this.babyId,
    required this.date,
    required this.weight,
    required this.height,
    this.headCircumference,
    required this.notes,
  });
}
