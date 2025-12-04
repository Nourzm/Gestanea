class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String gender;
  final String phone;
  final String? email;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int? yearsExperience;
  final String? photoUrl;
  final DateTime createdAt;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.gender,
    required this.phone,
    this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.yearsExperience,
    this.photoUrl,
    required this.createdAt,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      gender: map['gender'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String?,
      address: map['address'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      yearsExperience: map['years_experience'] as int?,
      photoUrl: map['photo_url'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'gender': gender,
      'phone': phone,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'years_experience': yearsExperience,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
