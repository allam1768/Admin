import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../../../data/models/catch_model.dart';
import '../../../../routes/routes.dart';

class DetailController extends GetxController {
  // Observable variables
  final title = "".obs;
  final namaKaryawan = "".obs;
  final nomorKaryawan = "".obs;
  final tanggalJam = "".obs;
  final kondisi = "".obs;
  final jumlah = "".obs;
  final informasi = "".obs;
  final imagePath = "assets/images/example.png".obs;
  final jenisHama = "".obs;
  final lokasi = "".obs;
  final detailLokasi = "".obs;
  final kodeQR = "".obs;
  final tanggal = "".obs;
  final namaAlat = "".obs;
  final catchId = 0.obs;

  final canEdit = true.obs; // Selalu true
  final isLoading = false.obs;
  final catchData = <String, dynamic>{}.obs;

  // Constants
  static const String baseUrl = 'https://hamatech.rplrus.com';
  static const String storageUrl = '$baseUrl/storage/';

  // HTTP client
  late final http.Client _httpClient;

  @override
  void onInit() {
    super.onInit();
    _httpClient = http.Client();
    loadDataFromArguments();
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }

  void loadDataFromArguments() {
    final arguments = Get.arguments;

    if (arguments != null && arguments is Map<String, dynamic>) {
      _setLoadingState(true);
      catchData.value = arguments;
      catchId.value = arguments['id'] ?? 0;

      if (catchId.value > 0) {
        fetchDetailData(catchId.value);
      } else {
        updateDataFromArguments();
      }
    } else {
      _loadFallbackData();
    }
  }

  Future<void> fetchDetailData(int id) async {
    try {
      _setLoadingState(true);

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/api/catches/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final catchDetail = responseData['data'] as Map<String, dynamic>;
        _updateDataFromAPI(catchDetail);
      } else {
        _handleApiError('Server returned status: ${response.statusCode}');
      }
    } on TimeoutException {
      _handleApiError('Request timeout - please check your connection');
    } on FormatException catch (e) {
      _handleApiError('Invalid response format: ${e.message}');
    } catch (e) {
      _handleApiError('Network error: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  void _handleApiError(String error) {
    debugPrint('API Error: $error');
    updateDataFromArguments();
    _showErrorSnackbar('Failed to load latest data, showing cached version');
  }

  void _updateDataFromAPI(Map<String, dynamic> data) {
    try {
      title.value = data['alat']?['nama_alat'] ?? 'Unknown Tool';
      namaKaryawan.value = data['dicatat_oleh'] ?? 'Unknown';
      nomorKaryawan.value = "ID: ${data['alat_id'] ?? 'N/A'}";

      _formatDateTime(data['tanggal'], data['created_at']);

      kondisi.value = _formatCondition(data['kondisi']);
      jumlah.value = data['jumlah']?.toString() ?? '0';
      jenisHama.value = data['jenis_hama'] ?? 'Unknown';
      informasi.value = data['catatan'] ?? 'No notes available';

      final alatData = data['alat'] as Map<String, dynamic>?;
      if (alatData != null) {
        namaAlat.value = alatData['nama_alat'] ?? 'Unknown Tool';
        lokasi.value = alatData['lokasi'] ?? 'Unknown location';
        detailLokasi.value = alatData['detail_lokasi'] ?? '';
        kodeQR.value = alatData['kode_qr'] ?? '';
      }

      if (data['image_url'] != null) {
        imagePath.value = data['image_url'];
      } else {
        _setImagePath(data['foto_dokumentasi']);
      }

    } catch (e) {
      debugPrint('Error updating data from API: $e');
      updateDataFromArguments();
    }
  }

  void updateDataFromArguments() {
    final arguments = catchData.value;

    title.value = arguments['name'] ?? 'Unknown Tool';
    namaKaryawan.value = arguments['dicatat_oleh'] ?? 'Unknown';
    nomorKaryawan.value = "ID: ${arguments['alat_id'] ?? 'N/A'}";
    tanggalJam.value =
    "${arguments['date'] ?? 'N/A'}   ${arguments['time'] ?? 'N/A'}";
    kondisi.value = _formatCondition(arguments['kondisi']);
    jumlah.value = arguments['jumlah']?.toString() ?? '0';
    jenisHama.value = arguments['jenis_hama'] ?? 'Unknown';
    informasi.value = arguments['catatan'] ?? 'No notes available';
    lokasi.value = arguments['lokasi'] ?? 'Unknown location';
    detailLokasi.value = arguments['detail_lokasi'] ?? '';
    kodeQR.value = arguments['kode_qr'] ?? '';
    tanggal.value = arguments['date'] ?? 'N/A';
    namaAlat.value = arguments['name'] ?? 'Unknown Tool';

    if (arguments['image_url'] != null) {
      imagePath.value = arguments['image_url'];
    } else {
      _setImagePath(arguments['foto_dokumentasi']);
    }
  }

  void _formatDateTime(String? dateStr, String? createdAtStr) {
    if (dateStr?.isNotEmpty == true && createdAtStr?.isNotEmpty == true) {
      try {
        final date = DateTime.parse(dateStr!);
        final createdAt = DateTime.parse(createdAtStr!);

        final formattedDate =
            "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
        final formattedTime =
            "${createdAt.hour.toString().padLeft(2, '0')}.${createdAt.minute.toString().padLeft(2, '0')}";

        tanggalJam.value = "$formattedDate   $formattedTime";
        tanggal.value = formattedDate;
      } catch (e) {
        debugPrint('Date parsing error: $e');
        tanggalJam.value = "${dateStr ?? 'N/A'}   N/A";
        tanggal.value = dateStr ?? 'N/A';
      }
    } else {
      tanggalJam.value = "N/A   N/A";
      tanggal.value = "N/A";
    }
  }

  void _setImagePath(String? imageUrl) {
    if (imageUrl?.isNotEmpty == true) {
      imagePath.value = CatchModel.getDisplayImageUrl(imageUrl);
    } else {
      imagePath.value = "assets/images/example.png";
    }
  }

  void _loadFallbackData() {
    title.value = "Fly 01 Utara";
    namaKaryawan.value = "Budi";
    nomorKaryawan.value = "Nomor Karyawan";
    tanggalJam.value = "13.05.2025   06.11";
    kondisi.value = "Baik";
    jumlah.value = "1000";
    informasi.value = "Lorem ipsum dolor sit amet.";
    imagePath.value = "assets/images/example.png";
    jenisHama.value = "Lalat Buah";
    lokasi.value = "Kebun Utara";
    detailLokasi.value = "Blok A1";
    kodeQR.value = "FLY001";
    tanggal.value = "13.05.2025";
    namaAlat.value = "Fly 01 Utara";
  }

  String _formatCondition(String? condition) {
    if (condition == null) return 'Unknown';

    switch (condition.toLowerCase()) {
      case 'good':
        return 'Aktif';
      case 'broken':
        return 'Tidak Aktif';
      case 'maintenance':
        return 'Maintenance';
      default:
        return condition;
    }
  }

  void updateDetailData(String newCondition, String newAmount,
      String newInformation, String newImage) {
    kondisi.value = newCondition;
    jumlah.value = newAmount;
    informasi.value = newInformation;
    imagePath.value = newImage;
  }

  Future<void> deleteData() async {
    try {
      _setLoadingState(true);

      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/api/catches/${catchId.value}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.back();
        _showSuccessSnackbar('Record deleted successfully');
      } else {
        _showErrorSnackbar('Failed to delete record: Server error');
      }
    } on TimeoutException {
      _showErrorSnackbar('Delete timeout - please try again');
    } catch (e) {
      _showErrorSnackbar('Error deleting record: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  void editData() {
    Get.toNamed(Routes.editDataHistory, arguments: catchData.value);
  }

  String getFullImageUrl(String imagePath) {
    return CatchModel.getDisplayImageUrl(imagePath);
  }

  Future<void> refreshData() async {
    if (catchId.value > 0) {
      await fetchDetailData(catchId.value);
    }
  }

  void debugImageInfo() {
    print('=== IMAGE DEBUG INFO ===');
    print('Original path: ${catchData.value['foto_dokumentasi']}');
    print('Processed URL: ${imagePath.value}');
    print('Has image_url in data: ${catchData.value.containsKey('image_url')}');
    if (catchData.value.containsKey('image_url')) {
      print('Cached image_url: ${catchData.value['image_url']}');
    }
    print('========================');
  }

  void _setLoadingState(bool loading) {
    isLoading.value = loading;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
