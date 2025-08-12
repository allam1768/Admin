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
    // Debug logging untuk melihat struktur JSON
    print('=== ClientModel.fromJson Debug ===');
    print('Full JSON: $json');
    print('Company field type: ${json['company'].runtimeType}');
    print('Company value: ${json['company']}');

    // Extract company name from nested object
    String? companyName;
    if (json['company'] != null) {
      if (json['company'] is Map<String, dynamic>) {
        // Company adalah object, ambil field 'name'
        companyName = json['company']['name'];
        print('Company name from object: $companyName');
      } else if (json['company'] is String) {
        // Company adalah string langsung
        companyName = json['company'];
        print('Company name from string: $companyName');
      }
    }
    print('Final company name: $companyName');
    print('================================');

    return ClientModel(
      id: json['id'],
      name: json['name'] ?? '-',
      company: companyName, // Menggunakan companyName yang sudah diextract
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