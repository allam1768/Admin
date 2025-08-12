import '../../values/config.dart';

class CompanyModel {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String? imagePath;
  final String? companyQr; // Tambahan field untuk QR code
  final String createdAt;
  final String updatedAt;
  final int? alatCount; // Tambahan untuk jumlah alat
  final ClientModel? client; // Tambahan untuk client info

  CompanyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.imagePath,
    this.companyQr,
    required this.createdAt,
    required this.updatedAt,
    this.alatCount,
    this.client,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      imagePath: json['image'] != null && json['image'].toString().isNotEmpty
          ? json['image'].toString()
          : null,
      companyQr: json['company_qr'], // QR code dari response
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      alatCount: json['alat_count'], // Jumlah alat
      client: json['client'] != null ? ClientModel.fromJson(json['client']) : null,
    );
  }

  // Helper method untuk mendapatkan image URL lengkap menggunakan Config
  String get fullImageUrl {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Config.getImageUrl(imagePath);
    }
    return Config.getImageUrl(null); // Return default image
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'image': imagePath,
      'company_qr': companyQr,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'alat_count': alatCount,
      'client': client?.toJson(),
    };
  }
}

// Model untuk client info
class ClientModel {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber; // Tambahan field phone number
  final String? imagePath; // Tambahan field image

  ClientModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.imagePath,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      imagePath: json['image'] != null && json['image'].toString().isNotEmpty
          ? json['image'].toString()
          : null,
    );
  }

  // Helper method untuk mendapatkan client image URL lengkap
  String get fullImageUrl {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Config.getImageUrl(imagePath);
    }
    return Config.getImageUrl(null); // Return default image
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'image': imagePath,
    };
  }
}