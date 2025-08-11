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

  /// Convert datetime string to WIB (UTC+7) format
  String convertToWIB(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'N/A';

    try {
      DateTime dateTime;

      // Parse the datetime string
      if (dateTimeString.contains('T')) {
        // ISO format: 2024-01-15T10:30:00Z or 2024-01-15T10:30:00
        dateTime = DateTime.parse(dateTimeString);
      } else if (dateTimeString.contains('-')) {
        // Format: 2024-01-15 10:30:00
        dateTime = DateTime.parse(dateTimeString);
      } else {
        // If parsing fails, return original string
        return dateTimeString;
      }

      // Convert to WIB (UTC+7)
      DateTime wibTime;
      if (dateTime.isUtc) {
        // If it's UTC, add 7 hours for WIB
        wibTime = dateTime.add(const Duration(hours: 7));
      } else {
        // If it's already local time, assume it's WIB or convert accordingly
        wibTime = dateTime.toLocal().add(const Duration(hours: 7));
      }

      // Format to Indonesian date format with WIB
      List<String> monthNames = [
        '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];

      String day = wibTime.day.toString().padLeft(2, '0');
      String month = monthNames[wibTime.month];
      String year = wibTime.year.toString();
      String hour = wibTime.hour.toString().padLeft(2, '0');
      String minute = wibTime.minute.toString().padLeft(2, '0');

      return '$day $month $year, $hour:$minute ';

    } catch (e) {
      print('Error converting datetime to WIB: $e');
      return dateTimeString; // Return original if conversion fails
    }
  }

  /// Alternative simple WIB conversion (just adds WIB suffix)
  String formatDateToWIB(String dateString) {
    if (dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);

      // Convert to WIB if needed (assuming input might be UTC)
      DateTime wibDate;
      if (date.isUtc) {
        wibDate = date.add(const Duration(hours: 7));
      } else {
        wibDate = date;
      }

      String day = wibDate.day.toString().padLeft(2, '0');
      String month = wibDate.month.toString().padLeft(2, '0');
      String year = wibDate.year.toString();
      String hour = wibDate.hour.toString().padLeft(2, '0');
      String minute = wibDate.minute.toString().padLeft(2, '0');

      return '$day/$month/$year $hour:$minute ';
    } catch (e) {
      print('Error formatting date to WIB: $e');
      return '$dateString '; // Fallback: just add WIB suffix
    }
  }

  /// Get current WIB time
  String getCurrentWIBTime() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String second = now.second.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute:$second';
  }

  Future<void> refreshCompanyDetail() async {
    try {
      // Untuk saat ini kita refresh dari data yang sudah ada
      // Nanti bisa ditambahkan API untuk get company by ID

      // Update timestamp with current WIB time
      String currentWIBTime = getCurrentWIBTime();

      Get.snackbar(
        'Info',
        'Data company telah diperbarui pada $currentWIBTime',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
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
      print('Company berhasil dihapus pada ${getCurrentWIBTime()}'); // Log success with WIB time

      Get.back(); // Tutup loading dialog

      Get.snackbar(
        'Berhasil',
        'Company berhasil dihapus pada ${getCurrentWIBTime()}',
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