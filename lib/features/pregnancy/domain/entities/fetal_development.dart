// lib/features/pregnancy/domain/entities/fetal_development.dart
class FetalDevelopment {
  final int week;
  final double weightInGrams;
  final double lengthInCm;
  final String description;
  final String imagePath;
  final List<String> developments;

  const FetalDevelopment({
    required this.week,
    required this.weightInGrams,
    required this.lengthInCm,
    required this.description,
    required this.imagePath,
    required this.developments,
  });
}
