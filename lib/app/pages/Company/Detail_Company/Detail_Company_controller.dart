import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/company_model.dart';
import '../../../../../data/services/company_service.dart';

class DetailCompanyController extends GetxController {
  final companyName = "".obs;
  final companyAddress = "".obs;
  final phoneNumber = "".obs;
  final email = "".obs;
  final imagePath = "".obs;
  final companyQr = "".obs; // Added QR field
  final createdAt = "".obs;
  final updatedAt = "".obs;
  final id = 0.obs;

  final CompanyService _companyService = CompanyService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args == null) {
      Get.snackbar(
        'Error',
        'Data company tidak ditemukan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi ID
    final companyId = args['id'];
    if (companyId == null || (companyId is! int) || companyId <= 0) {
      Get.snackbar(
        'Error',
        'ID company tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Set nilai setelah validasi
    id.value = companyId;
    companyName.value = args['name'] ?? '';
    companyAddress.value = args['address'] ?? '';
    phoneNumber.value = args['phoneNumber'] ?? '';
    email.value = args['email'] ?? '';
    imagePath.value = args['imagePath'] ?? '';
    companyQr.value = args['companyQr'] ?? ''; // Set QR value
    createdAt.value = args['createdAt'] ?? '';
    updatedAt.value = args['updatedAt'] ?? '';
  }

  Future<void> refreshCompanyDetail() async {
    try {
      // Untuk saat ini kita refresh dari data yang sudah ada
      // Nanti bisa ditambahkan API untuk get company by ID
      Get.snackbar(
        'Info',
        'Data company telah diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error refreshing company detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memperbarui data company',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void deleteCompany(int id) async {
    print('Mencoba menghapus company dengan ID: $id');

    // Validasi ID yang lebih ketat
    if (id <= 0 || this.id.value <= 0) {
      Get.snackbar(
        'Error',
        'ID company tidak valid atau belum diinisialisasi dengan benar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (id != this.id.value) {
      Get.snackbar(
        'Error',
        'ID company tidak sesuai dengan data yang ditampilkan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _companyService.deleteCompany(id);
      print('Company berhasil dihapus'); // Log success

      Get.back(); // Tutup loading dialog

      Get.snackbar(
        'Berhasil',
        'Company berhasil dihapus.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Kembali ke halaman sebelumnya
      Get.toNamed('/bottomnav');
    } catch (e) {
      print('Error saat menghapus company: $e'); // Log error
      Get.back(); // Tutup loading dialog jika masih terbuka
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}