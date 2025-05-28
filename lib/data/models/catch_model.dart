class CatchModel {
  final int? id;
  final String alatId;
  final String jenisHama;
  final int jumlah;
  final String tanggal;
  final String dicatatOleh;
  final String fotoDokumentasi;
  final String? imageUrl; // NEW: Processed image URL
  final String kondisi;
  final String catatan;
  final String? updatedAt;
  final String? createdAt;

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
  });

  factory CatchModel.fromJson(Map<String, dynamic> json) {
    return CatchModel(
      id: json['id'],
      alatId: json['alat_id'],
      jenisHama: json['jenis_hama'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      dicatatOleh: json['dicatat_oleh'],
      fotoDokumentasi: json['foto_dokumentasi'] ?? '',
      imageUrl: _processImageUrl(json['foto_dokumentasi']), // Process image URL
      kondisi: json['kondisi'],
      catatan: json['catatan'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
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

  // Static method to process image URL
  static String? _processImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null; // Return null for empty paths, will use default image
    }

    // If already a full URL, return as is
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // Process the image path based on folder structure
    const String baseUrl = 'https://hamatech.rplrus.com/storage';

    // If path already includes pest_catches folder
    if (imagePath.startsWith('pest_catches/')) {
      return '$baseUrl/$imagePath';
    } else {
      // Add pest_catches folder to the path
      return '$baseUrl/pest_catches/$imagePath';
    }
  }

  // Getter for image URL with fallback
  String get fullImageUrl {
    return imageUrl ?? 'assets/images/example.png';
  }

  // Method to check if image exists (has valid URL)
  bool get hasImage {
    return imageUrl != null && imageUrl!.isNotEmpty;
  }

  // Create copy with updated image
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
    );
  }

  // Helper method to get image URL for display
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
          other is CatchModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}