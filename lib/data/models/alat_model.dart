import '../../values/config.dart';

class AlatModel {
  final int id;
  final String namaAlat;
  final String lokasi;
  final String detailLokasi;
  final String pestType;
  final String kondisi;
  final String kodeQr;
  final String? imagePath;
  final int? companyId; // Added company ID field

  AlatModel({
    required this.id,
    required this.namaAlat,
    required this.lokasi,
    required this.detailLokasi,
    required this.pestType,
    required this.kondisi,
    required this.kodeQr,
    this.imagePath,
    this.companyId, // Added company ID parameter
  });

  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      id: json['id'] ?? 0,
      namaAlat: json['nama_alat'] ?? '',
      lokasi: json['lokasi'] ?? '',
      detailLokasi: json['detail_lokasi'] ?? '',
      pestType: json['pest_type'] ?? '',
      kondisi: json['kondisi'] ?? '',
      kodeQr: json['kode_qr'] ?? '',
      imagePath: json['alat_image'] != null && json['alat_image'].toString().isNotEmpty
          ? json['alat_image'].toString()
          : null,
      companyId: json['company_id'], // Added company ID from JSON
    );
  }

  // PERBAIKAN: Helper method untuk mendapatkan image URL lengkap menggunakan Config
  String get fullImageUrl {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Config.getImageUrl(imagePath);
    }
    return Config.getImageUrl(null); // Return default image
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_alat': namaAlat,
      'lokasi': lokasi,
      'detail_lokasi': detailLokasi,
      'pest_type': pestType,
      'kondisi': kondisi,
      'kode_qr': kodeQr,
      'alat_image': imagePath,
      'company_id': companyId, // Added company ID to JSON
    };
  }

  // TAMBAHAN: Helper method untuk copy dengan perubahan
  AlatModel copyWith({
    int? id,
    String? namaAlat,
    String? lokasi,
    String? detailLokasi,
    String? pestType,
    String? kondisi,
    String? kodeQr,
    String? imagePath,
    int? companyId,
  }) {
    return AlatModel(
      id: id ?? this.id,
      namaAlat: namaAlat ?? this.namaAlat,
      lokasi: lokasi ?? this.lokasi,
      detailLokasi: detailLokasi ?? this.detailLokasi,
      pestType: pestType ?? this.pestType,
      kondisi: kondisi ?? this.kondisi,
      kodeQr: kodeQr ?? this.kodeQr,
      imagePath: imagePath ?? this.imagePath,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  String toString() {
    return 'AlatModel(id: $id, namaAlat: $namaAlat, lokasi: $lokasi, pestType: $pestType, companyId: $companyId)';
  }
}