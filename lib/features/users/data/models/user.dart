class User {
  const User({
    required this.id,
    required this.mail,
    required this.name,
    required this.age,
    required this.createdAt,
    required this.addedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final createdAt = json['created_at'] as String;
    return User(
      id: json['id'] as String,
      mail: json['mail'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      createdAt: DateTime.parse(createdAt),
      // The openapi spec says `added_at`, but the auth service actually
      // sends `updated_at`; accept either.
      addedAt: DateTime.parse(
        json['added_at'] as String? ?? json['updated_at'] as String? ?? createdAt,
      ),
    );
  }

  final String id;
  final String mail;
  final String name;
  final int age;
  final DateTime createdAt;
  final DateTime addedAt;
}
