import 'package:intl/intl.dart';

class CatchModel {
  final int? id;
  final String alatId;
  final String jenisHama;
  final int jumlah;
  final String tanggal;
  final String dicatatOleh;
  final String fotoDokumentasi;
  final String? imageUrl;
  final String kondisi;
  final String catatan;
  final String? updatedAt;
  final String? createdAt;

  // Baru: waktu dalam format WIB string
  final String? createdAtWib;
  final String? updatedAtWib;

  CatchModel({
    this.id,
    required this.alatId,
    required this.jenisHama,
    required this.jumlah,
    required this.tanggal,
    required this.dicatatOleh,
    required this.fotoDokumentasi,
    this.imageUrl,
    required this.kondisi,
    required this.catatan,
    this.updatedAt,
    this.createdAt,
    this.createdAtWib,
    this.updatedAtWib,
  });

  factory CatchModel.fromJson(Map<String, dynamic> json) {
    String? created = json['created_at'];
    String? updated = json['updated_at'];

    // Parsing dan konversi waktu ke lokal (WIB)
    String? createdWib = _formatDateToWib(created);
    String? updatedWib = _formatDateToWib(updated);

    return CatchModel(
      id: json['id'],
      alatId: json['alat_id'],
      jenisHama: json['jenis_hama'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      dicatatOleh: json['dicatat_oleh'],
      fotoDokumentasi: json['foto_dokumentasi'] ?? '',
      imageUrl: _processImageUrl(json['foto_dokumentasi']),
      kondisi: json['kondisi'],
      catatan: json['catatan'],
      updatedAt: updated,
      createdAt: created,
      createdAtWib: createdWib,
      updatedAtWib: updatedWib,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alat_id': alatId,
      'jenis_hama': jenisHama,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'dicatat_oleh': dicatatOleh,
      'foto_dokumentasi': fotoDokumentasi,
      'kondisi': kondisi,
      'catatan': catatan,
    };
  }

  static String? _formatDateToWib(String? utcTime) {
    if (utcTime == null) return null;
    try {
      final dateTime = DateTime.parse(utcTime).toLocal();
      return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
    } catch (_) {
      return null;
    }
  }

  static String? _processImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    const String baseUrl = 'https://hamatech.rplrus.com/storage';

    if (imagePath.startsWith('pest_catches/')) {
      return '$baseUrl/$imagePath';
    } else {
      return '$baseUrl/pest_catches/$imagePath';
    }
  }

  String get fullImageUrl {
    return imageUrl ?? 'assets/images/example.png';
  }

  bool get hasImage {
    return imageUrl != null && imageUrl!.isNotEmpty;
  }

  CatchModel copyWith({
    int? id,
    String? alatId,
    String? jenisHama,
    int? jumlah,
    String? tanggal,
    String? dicatatOleh,
    String? fotoDokumentasi,
    String? imageUrl,
    String? kondisi,
    String? catatan,
    String? updatedAt,
    String? createdAt,
    String? createdAtWib,
    String? updatedAtWib,
  }) {
    return CatchModel(
      id: id ?? this.id,
      alatId: alatId ?? this.alatId,
      jenisHama: jenisHama ?? this.jenisHama,
      jumlah: jumlah ?? this.jumlah,
      tanggal: tanggal ?? this.tanggal,
      dicatatOleh: dicatatOleh ?? this.dicatatOleh,
      fotoDokumentasi: fotoDokumentasi ?? this.fotoDokumentasi,
      imageUrl: imageUrl ?? this.imageUrl,
      kondisi: kondisi ?? this.kondisi,
      catatan: catatan ?? this.catatan,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      createdAtWib: createdAtWib ?? this.createdAtWib,
      updatedAtWib: updatedAtWib ?? this.updatedAtWib,
    );
  }

  static String getDisplayImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'assets/images/example.png';
    }

    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    const String baseUrl = 'https://hamatech.rplrus.com/storage';

    if (imagePath.startsWith('pest_catches/')) {
      return '$baseUrl/$imagePath';
    } else {
      return '$baseUrl/pest_catches/$imagePath';
    }
  }

  @override
  String toString() {
    return 'CatchModel{id: $id, jenisHama: $jenisHama, jumlah: $jumlah, imageUrl: $imageUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CatchModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
