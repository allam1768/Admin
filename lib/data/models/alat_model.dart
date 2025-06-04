// alat_model.dart
class AlatModel {
  final int id;
  final String namaAlat;
  final String lokasi;
  final String detailLokasi;
  final String pestType;
  final String kondisi;
  final String kodeQr;
  final String? imagePath;

  AlatModel({
    required this.id,
    required this.namaAlat,
    required this.lokasi,
    required this.detailLokasi,
    required this.pestType,
    required this.kondisi,
    required this.kodeQr,
    this.imagePath,
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
          ? 'https://hamatech.rplrus.com/storage/${json['alat_image']}'
          : null,
    );
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
    };
  }
}