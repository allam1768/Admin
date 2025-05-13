class AlatModel {
  final String namaAlat;
  final String lokasi;
  final String detail_lokasi;
  final String pestType;
  final String kondisi;
  final String kodeQr;
  final String? imagePath; // optional

  AlatModel({
    required this.namaAlat,
    required this.lokasi,
    required this.detail_lokasi,
    required this.pestType,
    required this.kondisi,
    required this.kodeQr,
    this.imagePath,
  });

  Map<String, String> toJson() {
    return {
      'nama_alat': namaAlat,
      'lokasi': lokasi,
      'detail_lokasi':detail_lokasi,
      'pest_type': pestType,
      'kondisi': kondisi,
      'kode_qr': kodeQr,
    };
  }
}
