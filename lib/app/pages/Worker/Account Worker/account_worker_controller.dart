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

  // Base URL untuk server - sama seperti client controller
  static const String baseUrl = "https://hamatech.rplrus.com";

  @override
  void onInit() {
    super.onInit();
    _loadWorkerData();
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
        createdAt.value = _formatCreatedAt(worker.createdAt);

        print('Original image: "${worker.image}"');
        print('Processed image path: "${userImage.value}"');

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

  // Helper method untuk format tanggal - sama seperti client
  String _formatCreatedAt(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return "Tanggal tidak tersedia";
    }

    try {
      // Parse ISO string ke DateTime
      DateTime dateTime = DateTime.parse(createdAt);

      // Format ke format yang lebih readable seperti client controller
      String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return createdAt; // Return original jika error
    }
  }
}