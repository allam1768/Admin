class CompanyModel {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String? imagePath;
  final String createdAt;
  final String updatedAt;

  CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      imagePath: json['image'] != null && json['image'].toString().isNotEmpty
          ? 'https://hamatech.rplrus.com/storage/${json['image']}'
          : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'image': imagePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
