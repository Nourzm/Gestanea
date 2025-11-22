class Doctor {
  final String name;
  final String specialty;
  final String distance;
  final double rating;
  final int reviews;
  final String gender; // Add this field

  Doctor({
    required this.name,
    required this.specialty,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.gender, // Add this
  });

  // Helper method to get distance as double (in km)
  double get distanceInKm {
    final distanceStr = distance.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(distanceStr) ?? 0.0;
  }
}
