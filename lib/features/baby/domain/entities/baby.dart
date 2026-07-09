// lib/features/baby/domain/entities/baby.dart
class Baby {
  final String id;
  final String name;
  final String gender; // 'girl' or 'boy'
  final DateTime dateOfBirth;
  final double? currentWeight; // in kg
  final double? currentHeight; // in cm
  final String growthStatus; // 'on track', 'below average', 'above average'

  const Baby({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    this.currentWeight,
    this.currentHeight,
    required this.growthStatus,
  });

  int get ageInMonths {
    final now = DateTime.now();
    return ((now.year - dateOfBirth.year) * 12) +
        (now.month - dateOfBirth.month);
  }

  int get ageInDays {
    return DateTime.now().difference(dateOfBirth).inDays;
  }

  String get ageDisplay {
    if (ageInMonths < 12) {
      return '$ageInMonths months old';
    }
    final years = ageInMonths ~/ 12;
    final months = ageInMonths % 12;
    return months > 0 ? '$years years $months months old' : '$years years old';
  }
}
