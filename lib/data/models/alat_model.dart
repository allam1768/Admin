class AlatModel {
  final String namaAlat;
  final String lokasi;
  final String detail_lokasi;
  final String pestType;
  final String kondisi;
  final String kodeQr;
  final String? imagePath;

  bool isExpanded; // 🔥 baru
  List<Map<String, dynamic>> history; // 🔥 baru

  AlatModel({
    required this.namaAlat,
    required this.lokasi,
    required this.detail_lokasi,
    required this.pestType,
    required this.kondisi,
    required this.kodeQr,
    this.imagePath,
    this.isExpanded = false,
    this.history = const [],
  });

  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      namaAlat: json['nama_alat'] ?? '',
      lokasi: json['lokasi'] ?? '',
      detail_lokasi: json['detail_lokasi'] ?? '',
      pestType: json['pest_type'] ?? '',
      kondisi: json['kondisi'] ?? '',
      kodeQr: json['kode_qr'] ?? '',
      imagePath: json['alat_image'] != null
          ? "https://bfe1-36-81-11-141.ngrok-free.app/storage/${json['alat_image']}"
          : null,
      // kamu bisa isi ini kalau history ada dari API
      history: List<Map<String, dynamic>>.from(json['history'] ?? []),
    );
  }
}
