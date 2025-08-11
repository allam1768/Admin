import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/worker_model.dart';
import '../../../../data/services/worker_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class AccountWorkerController extends GetxController {
  // Observable variables untuk data worker
  final workerData = Rxn<WorkerModel>();
  final userName = "".obs;
  final userEmail = "".obs;
  final fullName = "".obs;
  final phoneNumber = "".obs;
  final userImage = "".obs;
  final workerId = "".obs;
  final createdAt = "".obs;

  final isPasswordVisible = false.obs;
  final isLoading = true.obs;

  static const String baseUrl = "https://hamatech.rplrus.com";

  @override
  void onInit() {
    super.onInit();
    _loadWorkerData();
  }

  /// Konversi waktu UTC ke WIB (UTC+7)
  String convertUtcToWib(String utcTimeString) {
    try {
      // Parse UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Konversi ke WIB (UTC+7)
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      // Format ke string yang diinginkan
      return "${wibTime.day.toString().padLeft(2, '0')}/${wibTime.month.toString().padLeft(2, '0')}/${wibTime.year}";
    } catch (e) {
      print("Error converting UTC to WIB: $e");
      return utcTimeString; // Return original string jika error
    }
  }

  /// Konversi waktu UTC ke WIB dengan format lengkap (termasuk jam, menit, detik)
  String convertUtcToWibFull(String utcTimeString) {
    try {
      // Parse UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Konversi ke WIB (UTC+7)
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      // Format lengkap: DD/MM/YYYY HH:mm:ss WIB
      return "${wibTime.day.toString().padLeft(2, '0')}/${wibTime.month.toString().padLeft(2, '0')}/${wibTime.year} "
          "${wibTime.hour.toString().padLeft(2, '0')}:${wibTime.minute.toString().padLeft(2, '0')}:${wibTime.second.toString().padLeft(2, '0')} WIB";
    } catch (e) {
      print("Error converting UTC to WIB: $e");
      return utcTimeString; // Return original string jika error
    }
  }

  /// Konversi waktu UTC ke WIB dengan format custom
  String convertUtcToWibCustom(String utcTimeString, {bool includeTime = false, bool includeWibSuffix = true}) {
    try {
      // Parse UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Konversi ke WIB (UTC+7)
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      String dateString = "${wibTime.day.toString().padLeft(2, '0')}/${wibTime.month.toString().padLeft(2, '0')}/${wibTime.year}";

      if (includeTime) {
        String timeString = "${wibTime.hour.toString().padLeft(2, '0')}:${wibTime.minute.toString().padLeft(2, '0')}";
        dateString += " $timeString";

        if (includeWibSuffix) {
          dateString += " WIB";
        }
      }

      return dateString;
    } catch (e) {
      print("Error converting UTC to WIB: $e");
      return utcTimeString; // Return original string jika error
    }
  }

  void _loadWorkerData() {
    try {
      isLoading.value = true;

      // Ambil data worker dari arguments
      final WorkerModel? worker = Get.arguments as WorkerModel?;

      print('=== LOADING WORKER DATA ===');
      print('Received worker: $worker');

      if (worker != null) {
        workerData.value = worker;
        userName.value = worker.name ?? "";
        userEmail.value = worker.email ?? "";
        fullName.value = worker.name ?? "";
        phoneNumber.value = worker.phoneNumber ?? "";

        // Process image path sama seperti client controller
        userImage.value = _processImagePath(worker.image);

        workerId.value = worker.id?.toString() ?? "";

        // Gunakan fungsi konversi UTC ke WIB untuk format tanggal
        createdAt.value = _formatCreatedAt(worker.createdAt);

        print('Original image: "${worker.image}"');
        print('Processed image path: "${userImage.value}"');
        print('Created At (UTC): "${worker.createdAt}"');
        print('Created At (WIB): "${createdAt.value}"');

      } else {
        print('No worker data received');
        _setDefaultValues();
      }
    } catch (e) {
      print('Error loading worker data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data worker: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      _setDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  void _setDefaultValues() {
    userName.value = "Data tidak tersedia";
    userEmail.value = "Email tidak tersedia";
    fullName.value = "Nama tidak tersedia";
    phoneNumber.value = "Nomor tidak tersedia";
    userImage.value = "";
    workerId.value = "ID tidak tersedia";
    createdAt.value = "Tanggal tidak tersedia";
  }

  /// Process image path - mengikuti pola client controller
  String _processImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      print('Image path is null or empty');
      return "assets/images/example.png"; // Default fallback
    }

    // Bersihkan path dari whitespace
    String cleanPath = imagePath.trim();
    print('Processing image path: "$cleanPath"');

    // Jika sudah berupa URL lengkap dengan http/https, return as is
    if (cleanPath.toLowerCase().startsWith('http://') ||
        cleanPath.toLowerCase().startsWith('https://')) {
      print('Image path is already a full URL');
      return cleanPath;
    }

    // Jika path relatif, gabungkan dengan base URL seperti client controller
    // Format: https://hamatech.rplrus.com/storage/path_to_image
    String fullUrl;

    if (cleanPath.startsWith('/storage/')) {
      fullUrl = baseUrl + cleanPath;
    } else if (cleanPath.startsWith('storage/')) {
      fullUrl = baseUrl + '/' + cleanPath;
    } else {
      // Asumsikan path relatif di dalam storage
      fullUrl = '$baseUrl/storage/$cleanPath';
    }

    print('Converted to full URL: $fullUrl');
    return fullUrl;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Update data akun
  void updateAccount({
    required String name,
    required String email,
    required String fullName,
    required String phone,
    String? imagePath,
  }) {
    userName.value = name;
    userEmail.value = email;
    this.fullName.value = fullName;
    phoneNumber.value = phone;

    // Update image path jika disediakan
    if (imagePath != null) {
      userImage.value = _processImagePath(imagePath);
    }
  }

  /// Method untuk refresh data worker (misalnya setelah update)
  void refreshWorkerData() {
    _loadWorkerData();
  }

  void deleteAccount() async {
    try {
      isLoading.value = true;
      final success = await WorkerService.deleteWorker(workerId.value);
      if (success) {
        Get.snackbar(
          'Success',
          'Akun worker berhasil dihapus',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate back or to a different screen after successful deletion
        Get.find<BottomNavController>().selectedIndex.value = 2;
        Get.offNamed('/bottomnav');
      } else {
        Get.snackbar(
          'Error',
          'Gagal menghapus akun worker. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error deleting worker: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 2;
    Get.offNamed('/bottomnav');
  }

  void navigateToEditAccount() {
    // Pass worker data ke edit page juga
    Get.toNamed('/EditAccountWorker', arguments: workerData.value);
  }

  // Helper method untuk format tanggal dengan konversi UTC ke WIB
  String _formatCreatedAt(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return "Tanggal tidak tersedia";
    }

    try {
      // Gunakan fungsi konversi UTC ke WIB
      return convertUtcToWib(createdAt);
    } catch (e) {
      print('Error formatting date with WIB conversion: $e');
      // Fallback ke method lama jika ada error
      try {
        DateTime dateTime = DateTime.parse(createdAt);
        String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
        return formattedDate;
      } catch (e2) {
        print('Error with fallback formatting: $e2');
        return createdAt; // Return original jika semua error
      }
    }
  }
}