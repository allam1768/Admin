class UserModel {
  final int id;
  final String name;
  final String role;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("Parsing user json: $json"); // debug log

    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'email': email,
      };
}
