class User {
  final String id;
  final String email;
  final String name;
  final String address;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      address: json['address'],
    );
  }
}
