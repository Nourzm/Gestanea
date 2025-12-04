class Baby {
  final String id;
  final String userId;
  final String name;
  final String gender;
  final DateTime birthDate;
  final double? birthWeight;
  final double? birthHeight;
  final String? bloodType;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Baby({
    required this.id,
    required this.userId,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.birthWeight,
    this.birthHeight,
    this.bloodType,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Baby.fromMap(Map<String, dynamic> map) {
    return Baby(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      gender: map['gender'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      birthWeight: map['birth_weight'] != null ? (map['birth_weight'] as num).toDouble() : null,
      birthHeight: map['birth_height'] != null ? (map['birth_height'] as num).toDouble() : null,
      bloodType: map['blood_type'] as String?,
      profileImage: map['profile_image'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(),
      'birth_weight': birthWeight,
      'birth_height': birthHeight,
      'blood_type': bloodType,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - birthDate.year) * 12;
    months += now.month - birthDate.month;
    if (now.day < birthDate.day) {
      months--;
    }
    return months;
  }

  int get ageInDays {
    final now = DateTime.now();
    return now.difference(birthDate).inDays;
  }

  Baby copyWith({
    String? id,
    String? userId,
    String? name,
    String? gender,
    DateTime? birthDate,
    double? birthWeight,
    double? birthHeight,
    String? bloodType,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Baby(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      bloodType: bloodType ?? this.bloodType,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
