class DoctorEntity {
  final String name;
  final String specialty;
  final String address;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final double rating;
  final int totalReviews;
  final String openingHours;
  final String gender;

  DoctorEntity({
    required this.name,
    required this.specialty,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.rating,
    required this.totalReviews,
    required this.openingHours,
    required this.gender,
  });

  // Factory to create from Map (coming from mock data)
  factory DoctorEntity.fromMap(Map<String, dynamic> map) {
    return DoctorEntity(
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      distanceKm: map['distance_km'] ?? 0.0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalReviews: map['total_reviews'] ?? 0,
      openingHours: map['opening_hours'] ?? '',
      gender: map['gender'] ?? 'Unknown',
    );
  }

  // Convert to Map for UI
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'address': address,
      'phone_number': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm,
      'rating': rating,
      'total_reviews': totalReviews,
      'opening_hours': openingHours,
      'gender': gender,
    };
  }
}
