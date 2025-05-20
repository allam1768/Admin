class WorkerModel {
  final int id;
  final String name;
  final String role;
  final String? phoneNumber;
  final String? image;
  final String? rememberToken;
  final String createdAt;
  final String updatedAt;

  WorkerModel({
    required this.id,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.image,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      phoneNumber: json['phone_number'],
      image: json['image'],
      rememberToken: json['remember_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone_number': phoneNumber,
      'image': image,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
