import '../../values/config.dart';

class ClientModel {
  final int id;
  final String name;
  final String? company;
  final String? image;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? createdAt;

  ClientModel({
    required this.id,
    required this.name,
    this.company,
    this.image,
    this.email,
    this.phoneNumber,
    this.role,
    this.createdAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'] ?? '-',
      company: json['name_company'],
      image: json['image'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_company': company,
      'image': image,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'created_at': createdAt,
    };
  }

  String? get fullImageUrl {
    if (image != null && image!.isNotEmpty) {
      if (image!.startsWith('http')) {
        return image;
      } else {
        return Config.getImageUrl(image);
      }
    }
    return null;
  }
}