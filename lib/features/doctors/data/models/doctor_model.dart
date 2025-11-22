class Doctor {
  final String name;
  final String specialty;
  final String distance;
  final double rating;
  final int reviews;
  final String gender;
  final String? address;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final String? openingHours;

  Doctor({
    required this.name,
    required this.specialty,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.gender,
    this.address,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.openingHours,
  });

  // Convert Doctor to Map for DoctorDetailScreen
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'address': address,
      'phone_number': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm ?? distanceInKm,
      'rating': rating,
      'total_reviews': reviews,
      'opening_hours': openingHours,
    };
  }

  // Helper method to get distance as double (in km)
  double get distanceInKm {
    final distanceStr = distance.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(distanceStr) ?? 0.0;
  }
}
