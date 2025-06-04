import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../../../../data/models/catch_model.dart';

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

  final canEdit = true.obs;
  final editTimeExpired = false.obs; // NEW: Track if edit time has expired
  final isLoading = false.obs;
  final catchData = <String, dynamic>{}.obs;

  // Constants
  static const String baseUrl = 'https://hamatech.rplrus.com';
  static const String storageUrl = '$baseUrl/storage/';
  static const int editTimeLimit = 4 * 60; // 4 hours in minutes

  // HTTP client with timeout
  late final http.Client _httpClient;
  Timer? _editTimer;

  @override
  void onInit() {
    super.onInit();
    _httpClient = http.Client();
    loadDataFromArguments();
  }

  @override
  void onClose() {
    _httpClient.close();
    _editTimer?.cancel();
    super.onClose();
  }

  /// Load initial data from route arguments
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

  /// Fetch detailed data from API with improved error handling
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

  /// Handle API errors gracefully
  void _handleApiError(String error) {
    debugPrint('API Error: $error');
    updateDataFromArguments();
    _showErrorSnackbar('Failed to load latest data, showing cached version');
  }

  /// Update data from API response
  void _updateDataFromAPI(Map<String, dynamic> data) {
    try {
      // Basic info
      title.value = data['alat']?['nama_alat'] ?? 'Unknown Tool';
      namaKaryawan.value = data['dicatat_oleh'] ?? 'Unknown';
      nomorKaryawan.value = "ID: ${data['alat_id'] ?? 'N/A'}";

      // Date and time formatting
      _formatDateTime(data['tanggal'], data['created_at']);

      // Catch details
      kondisi.value = _formatCondition(data['kondisi']);
      jumlah.value = data['jumlah']?.toString() ?? '0';
      jenisHama.value = data['jenis_hama'] ?? 'Unknown';
      informasi.value = data['catatan'] ?? 'No notes available';

      // Tool information
      final alatData = data['alat'] as Map<String, dynamic>?;
      if (alatData != null) {
        namaAlat.value = alatData['nama_alat'] ?? 'Unknown Tool';
        lokasi.value = alatData['lokasi'] ?? 'Unknown location';
        detailLokasi.value = alatData['detail_lokasi'] ?? '';
        kodeQR.value = alatData['kode_qr'] ?? '';
      }

      // IMPROVED: Use processed image URL from API response if available
      if (data['image_url'] != null) {
        imagePath.value = data['image_url'];
      } else {
        _setImagePath(data['foto_dokumentasi']);
      }

      // Check edit permissions using created_at from API
      _checkEditTimeLimitFromAPI(data['created_at']);
    } catch (e) {
      debugPrint('Error updating data from API: $e');
      updateDataFromArguments();
    }
  }

  /// Update data from cached arguments
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

    // IMPROVED: Use processed image URL if available, otherwise process the original path
    if (arguments['image_url'] != null) {
      imagePath.value = arguments['image_url'];
    } else {
      _setImagePath(arguments['foto_dokumentasi']);
    }

    _checkEditTimeLimitFromArguments();
  }

  /// NEW: Check edit time limit using API created_at
  void _checkEditTimeLimitFromAPI(String? createdAtStr) {
    try {
      if (createdAtStr != null && createdAtStr.isNotEmpty) {
        final createdAt = DateTime.parse(createdAtStr);
        final now = DateTime.now();
        final difference = now.difference(createdAt);

        // Check if more than 4 hours have passed
        editTimeExpired.value = difference.inHours >= 4;
        canEdit.value = difference.inHours < 4;

        // Setup timer to update status when 4 hours pass
        if (!editTimeExpired.value) {
          final remainingTime = Duration(hours: 4) - difference;
          if (remainingTime.inMilliseconds > 0) {
            _editTimer?.cancel();
            _editTimer = Timer(remainingTime, () {
              editTimeExpired.value = true;
              canEdit.value = false;
            });
          }
        }
      } else {
        // If no created_at, don't allow editing
        editTimeExpired.value = true;
        canEdit.value = false;
      }
    } catch (e) {
      debugPrint('Error checking edit time limit from API: $e');
      editTimeExpired.value = true;
      canEdit.value = false;
    }
  }

  /// NEW: Check edit time limit from cached arguments
  void _checkEditTimeLimitFromArguments() {
    try {
      final arguments = catchData.value;
      final createdAtStr = arguments['created_at'];

      if (createdAtStr != null && createdAtStr.toString().isNotEmpty) {
        final createdAt = DateTime.parse(createdAtStr.toString());
        final now = DateTime.now();
        final difference = now.difference(createdAt);

        // Check if more than 4 hours have passed
        editTimeExpired.value = difference.inHours >= 4;
        canEdit.value = difference.inHours < 4;

        // Setup timer to update status when 4 hours pass
        if (!editTimeExpired.value) {
          final remainingTime = Duration(hours: 4) - difference;
          if (remainingTime.inMilliseconds > 0) {
            _editTimer?.cancel();
            _editTimer = Timer(remainingTime, () {
              editTimeExpired.value = true;
              canEdit.value = false;
            });
          }
        }
      } else {
        // Fallback to old method if no created_at available
        _checkEditStatus();
      }
    } catch (e) {
      debugPrint('Error checking edit time limit from arguments: $e');
      // Fallback to old method
      _checkEditStatus();
    }
  }

  /// Format date and time from API response
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

  /// Set image path with proper URL handling using CatchModel
  void _setImagePath(String? imageUrl) {
    if (imageUrl?.isNotEmpty == true) {
      // Use CatchModel's image processing method
      imagePath.value = CatchModel.getDisplayImageUrl(imageUrl);
    } else {
      imagePath.value = "assets/images/example.png";
    }
  }

  /// Load fallback dummy data
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
    _checkEditStatus();
  }

  /// Format condition text
  String _formatCondition(String? condition) {
    if (condition == null) return 'Unknown';

    switch (condition.toLowerCase()) {
      case 'good':
        return 'Baik';
      case 'broken':
        return 'Rusak';
      case 'maintenance':
        return 'Maintenance';
      default:
        return condition;
    }
  }

  /// Check if data can still be edited (OLD METHOD - kept as fallback)
  void _checkEditStatus() {
    try {
      final parts = tanggalJam.value.split('   ');
      if (parts.length != 2) {
        canEdit.value = false;
        editTimeExpired.value = true;
        return;
      }

      final datePart = parts[0];
      final timePart = parts[1];
      final dateComponents = datePart.split('.');

      if (dateComponents.length != 3) {
        canEdit.value = false;
        editTimeExpired.value = true;
        return;
      }

      final formatted =
          "${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]} $timePart";
      final inputTime = DateTime.parse(formatted);
      final difference = DateTime.now().difference(inputTime);

      editTimeExpired.value = difference.inHours >= 4;
      canEdit.value = difference.inMinutes < editTimeLimit;

      // Set up timer to update edit status
      _setupEditTimer(inputTime);
    } catch (e) {
      debugPrint("Error checking edit status: $e");
      canEdit.value = false;
      editTimeExpired.value = true;
    }
  }

  /// Setup timer to automatically update edit status
  void _setupEditTimer(DateTime inputTime) {
    _editTimer?.cancel();

    final timeLeft =
        editTimeLimit - DateTime.now().difference(inputTime).inMinutes;
    if (timeLeft > 0) {
      _editTimer = Timer(Duration(minutes: timeLeft), () {
        canEdit.value = false;
        editTimeExpired.value = true;
      });
    }
  }

  /// Get remaining edit time as formatted string
  String getRemainingEditTime() {
    try {
      final arguments = catchData.value;
      final createdAtStr = arguments['created_at'];

      if (createdAtStr != null) {
        final createdAt = DateTime.parse(createdAtStr.toString());
        final now = DateTime.now();
        final difference = now.difference(createdAt);
        final remainingTime = Duration(hours: 4) - difference;

        if (remainingTime.inMinutes > 0) {
          final hours = remainingTime.inHours;
          final minutes = remainingTime.inMinutes % 60;
          return "Can edit for $hours hours $minutes minutes";
        } else {
          return "Edit time expired";
        }
      }

      // Fallback to old method
      final parts = tanggalJam.value.split('   ');
      if (parts.length == 2) {
        final datePart = parts[0];
        final timePart = parts[1];
        final dateComponents = datePart.split('.');

        if (dateComponents.length == 3) {
          final formatted =
              "${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]} $timePart";
          final inputTime = DateTime.parse(formatted);
          final difference = DateTime.now().difference(inputTime);
          final remainingMinutes = editTimeLimit - difference.inMinutes;

          if (remainingMinutes > 0) {
            final hours = remainingMinutes ~/ 60;
            final minutes = remainingMinutes % 60;
            return "Can edit for $hours hours $minutes minutes";
          }
        }
      }
    } catch (e) {
      debugPrint("Error calculating remaining time: $e");
    }
    return "Edit time expired";
  }

  /// Update detail data (called from edit screen)
  void updateDetailData(String newCondition, String newAmount,
      String newInformation, String newImage) {
    kondisi.value = newCondition;
    jumlah.value = newAmount;
    informasi.value = newInformation;
    imagePath.value = newImage;
  }

  /// Delete catch data
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

  /// Navigate to edit screen
  void editData() {
    Get.toNamed('/EditData', arguments: catchData.value);
  }

  /// Get full image URL using CatchModel's method
  String getFullImageUrl(String imagePath) {
    return CatchModel.getDisplayImageUrl(imagePath);
  }

  /// Refresh data from API
  Future<void> refreshData() async {
    if (catchId.value > 0) {
      await fetchDetailData(catchId.value);
    }
  }

  /// Debug method for testing image processing
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

  // Helper methods
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