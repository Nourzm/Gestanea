class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? country;
  final String? language;
  final String? theme;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.country,
    this.language,
    this.theme,
    this.notificationsEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserEntity.fromModel(dynamic model) {
    // Accepts core UserModel or a map-like object with the same fields.
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      phone: model.phone,
      country: model.country,
      language: model.language,
      theme: model.theme,
      notificationsEnabled: model.notificationsEnabled,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}