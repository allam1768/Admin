import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../../data/services/alat_service.dart';
import '../../../Bottom Nav/bottomnav_controller.dart';

class DetailToolController extends GetxController {
  final namaAlat = "".obs;
  final kodeQr = "".obs;
  final lokasi = "".obs;
  final detailLokasi = "".obs;
  final kondisi = "".obs;
  final pestType = "".obs;
  final imagePath = "".obs;
  final id = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args == null) {
      Get.snackbar(
        'Error',
        'Data alat tidak ditemukan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi ID
    final toolId = args['id'];
    if (toolId == null || (toolId is! int) || toolId <= 0) {
      Get.snackbar(
        'Error',
        'ID alat tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Set nilai setelah validasi
    id.value = toolId;
    namaAlat.value = args['toolName'] ?? '';
    kodeQr.value = args['kodeQr'] ?? '';
    lokasi.value = args['location'] ?? '';
    detailLokasi.value = args['locationDetail'] ?? '';
    kondisi.value = args['kondisi'] ?? '';
    pestType.value = args['pestType'] ?? '';
    imagePath.value = args['imagePath'] ?? 'assets/images/broken.png';
  }

  Future<void> refreshToolDetail() async {
    try {
      final response = await AlatService.getAlatById(1);
      if (response != null && response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        final alat = AlatModel.fromJson(data);
        print('Nama alat: ${alat.namaAlat}');
      }
    } catch (e) {
      print('Error refreshing tool detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memperbarui data alat',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void deleteTool(int id) async {
    print('Mencoba menghapus alat dengan ID: $id');

    // Validasi ID yang lebih ketat
    if (id <= 0 || this.id.value <= 0) {
      Get.snackbar(
        'Error',
        'ID alat tidak valid atau belum diinisialisasi dengan benar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (id != this.id.value) {
      Get.snackbar(
        'Error',
        'ID alat tidak sesuai dengan data yang ditampilkan',
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

      final response = await AlatService.deleteAlat(id);
      print('Response status: ${response?.statusCode}'); // Log response status
      print('Response body: ${response?.body}'); // Log response body

      Get.back(); // Tutup loading dialog

      if (response != null && response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Alat berhasil dihapus.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/detaildata');
      } else {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan saat menghapus alat. Status: ${response?.statusCode}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error saat menghapus alat: $e'); // Log error
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
