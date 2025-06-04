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
        fullName.value = worker.name ?? ""; // Atau field lain jika ada
        phoneNumber.value = worker.phoneNumber ?? "";
        userImage.value = worker.image ?? "";
        workerId.value = worker.id?.toString() ?? "";
        createdAt.value = _formatCreatedAt(worker.createdAt);

      } else {
        print('No worker data received');
        // Set default values jika tidak ada data
        userName.value = "Data tidak tersedia";
        userEmail.value = "Email tidak tersedia";
        fullName.value = "Nama tidak tersedia";
        phoneNumber.value = "Nomor tidak tersedia";
        userImage.value = "";
        workerId.value = "ID tidak tersedia";
        createdAt.value = "Tanggal tidak tersedia";
      }
    } catch (e) {
      print('Error loading worker data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data worker: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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
  }) {
    userName.value = name;
    userEmail.value = email;
    this.fullName.value = fullName;
    phoneNumber.value = phone;
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
          backgroundColor: Colors.green, // You might need to import Colors
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

  // Helper method untuk format tanggal
  String _formatCreatedAt(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return "Tanggal tidak tersedia";
    }

    try {
      // Parse ISO string ke DateTime
      DateTime dateTime = DateTime.parse(createdAt);

      // Format ke format yang lebih readable
      String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.year} "
          "${dateTime.hour.toString().padLeft(2, '0')}:"
          "${dateTime.minute.toString().padLeft(2, '0')}";

      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return createdAt; // Return original jika error
    }
  }
}