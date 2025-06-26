class ChartModel {
  final String label;
  final String tanggal;
  final String pestType;
  final String namaAlat;
  final int value;

  ChartModel({
    required this.label,
    required this.tanggal,
    required this.pestType,
    required this.namaAlat,
    required this.value,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChartModel(
        label: json['label']?.toString() ?? '',
        tanggal: json['tanggal']?.toString() ?? '',
        pestType: json['pest_type']?.toString() ?? '',
        namaAlat: json['nama_alat']?.toString() ?? '',
        value: _parseIntSafely(json['value']),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to safely parse integer values
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'tanggal': tanggal,
      'pest_type': pestType,
      'nama_alat': namaAlat,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'ChartData(label: $label, tanggal: $tanggal, pestType: $pestType, namaAlat: $namaAlat, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartModel &&
        other.label == label &&
        other.tanggal == tanggal &&
        other.pestType == pestType &&
        other.namaAlat == namaAlat &&
        other.value == value;
  }

  @override
  int get hashCode {
    return label.hashCode ^
    tanggal.hashCode ^
    pestType.hashCode ^
    namaAlat.hashCode ^
    value.hashCode;
  }
}