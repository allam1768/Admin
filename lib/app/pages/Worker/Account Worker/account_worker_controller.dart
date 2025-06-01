import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/worker_model.dart';
import '../../../../data/services/worker_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class AccountWorkerController extends GetxController {
  // Observable untuk data worker
  final Rx<WorkerModel?> selectedWorker = Rx<WorkerModel?>(null);
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final WorkerService _workerService = WorkerService();

  @override
  void onInit() {
    super.onInit();
    // Ambil data worker yang dikirim dari halaman sebelumnya
    final WorkerModel? workerData = Get.arguments as WorkerModel?;
    if (workerData != null) {
      selectedWorker.value = workerData;
      print('=== CONTROLLER DEBUG ===');
      print('Worker data received: ${workerData.toJson()}');
      print('Worker email: ${workerData.email}');
      print('Worker displayEmail: ${workerData.displayEmail}');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Update data akun
  void updateAccount({
    required String name,
    required String email,
    required String phone,
  }) {
    if (selectedWorker.value != null) {
      // Update data lokal
      selectedWorker.value = WorkerModel(
        id: selectedWorker.value!.id,
        name: name,
        email: email.isEmpty ? null : email,
        role: selectedWorker.value!.role,
        phoneNumber: phone,
        image: selectedWorker.value!.image,
        rememberToken: selectedWorker.value!.rememberToken,
        createdAt: selectedWorker.value!.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<void> deleteAccount() async {
    if (selectedWorker.value == null) return;

    try {
      isLoading.value = true;

      // Implementasi delete worker di service (jika ada endpoint delete)
      // await _workerService.deleteWorker(selectedWorker.value!.id);

      Get.snackbar(
        'Sukses',
        'Akun worker berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Kembali ke dashboard
      goToDashboard();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus akun worker',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
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
    if (selectedWorker.value != null) {
      Get.toNamed('/EditAccountWorker', arguments: selectedWorker.value);
    }
  }

  // Getter untuk mendapatkan data worker dengan fallback
  String get workerName => selectedWorker.value?.name ?? "Tidak ada data";
  String get workerEmail {
    if (selectedWorker.value == null) return "Tidak ada data";
    // Tambahkan debug print untuk melihat nilai email
    print('Email value in controller: "${selectedWorker.value!.email}"');
    
    // Pastikan email ditampilkan dengan benar
    final email = selectedWorker.value!.email;
    if (email == null || email.isEmpty) {
      return "Email tidak tersedia";
    }
    return email;
  }
  String get workerPhone => selectedWorker.value?.phoneNumber ?? "Tidak ada data";
  String get workerId => selectedWorker.value?.id.toString() ?? "Tidak ada data";
  String get workerRole => selectedWorker.value?.role ?? "worker";
  String? get workerImage => selectedWorker.value?.image;

  // Method untuk mendapatkan URL gambar lengkap
  String? get workerImageUrl {
    if (workerImage == null || workerImage!.isEmpty) return null;

    if (workerImage!.startsWith('http')) {
      return workerImage;
    } else {
      return 'https://hamatech.rplrus.com/storage/$workerImage';
    }
  }

  // Method untuk check status email
  bool get hasValidEmail => selectedWorker.value?.hasValidEmail ?? false;

  // Method untuk mendapatkan raw email (bisa null)
  String? get rawEmail => selectedWorker.value?.email;
}