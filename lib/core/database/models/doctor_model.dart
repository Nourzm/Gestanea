class DoctorModel {
  final String id;
  final String name;
  final String? specialty;
  final double?  distance;
  final String? gender;
  final String? phone;
  final String? email;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final int reviewsCount;
  final String? address;
  final bool isFavorite;

  DoctorModel({
    required this.id,
    required this.name,
    this. specialty,
    this.distance,
    this.gender,
    this.phone,
    this. email,
    this.latitude,
    this.longitude,
    this.rating,
    this. reviewsCount = 0,
    this.address,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'distance': distance,
      'gender': gender,
      'phone': phone,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviews_count': reviewsCount,
      'address': address,
      'isfavorite': isFavorite ?  1 : 0,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String?,
      distance: map['distance'] != null
          ? (map['distance'] as num).toDouble()
          : null,
      gender: map['gender'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      latitude: map['latitude'] != null
          ?  (map['latitude'] as num). toDouble()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      rating: map['rating'] != null
          ? (map['rating'] as num).toDouble()
          : null,
      reviewsCount: map['reviews_count'] as int?  ?? 0,
      address: map['address'] as String?,
      isFavorite: (map['isfavorite'] as int?) == 1,
    );
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    double? distance,
    String? gender,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewsCount,
    String? address,
    bool? isFavorite,
  }) {
    return DoctorModel(
      id: id ??  this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      distance: distance ?? this. distance,
      gender: gender ??  this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this. latitude,
      longitude: longitude ??  this.longitude,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ??  this.reviewsCount,
      address: address ?? this.address,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}