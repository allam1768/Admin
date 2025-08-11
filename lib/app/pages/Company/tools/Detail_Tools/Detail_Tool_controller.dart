import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../../data/services/alat_service.dart';
import '../../../../../values/config.dart';
import '../../../Bottom Nav/bottomnav_controller.dart';

class DetailToolController extends GetxController {
  // Observable variables
  final namaAlat = "".obs;
  final kodeQr = "".obs;
  final lokasi = "".obs;
  final detailLokasi = "".obs;
  final kondisi = "".obs;
  final pestType = "".obs;
  final imagePath = "".obs;
  final id = 0.obs;

  // Loading state untuk skeletonizer
  final isLoading = false.obs;

  // Method untuk memfilter kondisi alat
  String filterKondisiAlat(String kondisiFromApi) {
    if (kondisiFromApi.toLowerCase() == 'good') {
      return 'Aktif';
    } else {
      return 'Tidak Aktif';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() async {
    isLoading.value = true;

    try {
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
      // Filter kondisi dari API sebelum menampilkan
      kondisi.value = filterKondisiAlat(args['kondisi'] ?? '');
      pestType.value = args['pestType'] ?? '';

      // Handle imagePath with proper fallback
      final rawImagePath = args['imagePath'] ?? '';
      imagePath.value = _processImagePath(rawImagePath);

      // Debug: Print processed image path
      print('🔧 Tool ID: ${id.value}');
      print('🖼️ Raw imagePath from args: $rawImagePath');
      print('🖼️ Processed imagePath: ${imagePath.value}');

      // Simulate loading delay untuk demonstrasi skeleton (bisa dihapus)
      await Future.delayed(Duration(milliseconds: 800));

    } catch (e) {
      print('❌ Error initializing data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk memproses image path
  String _processImagePath(String rawPath) {
    if (rawPath.isEmpty) {
      return 'assets/images/broken.png'; // Default fallback
    }

    // Jika sudah berupa URL lengkap atau path assets, return as is
    if (rawPath.startsWith('http') || rawPath.startsWith('assets/')) {
      return rawPath;
    }

    // Jika berupa path relatif, biarkan Config.getImageUrl() yang handle
    return rawPath;
  }

  Future<void> refreshToolDetail() async {
    isLoading.value = true;

    try {
      final response = await AlatService.getAlatById(id.value);
      if (response != null && response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        final alat = AlatModel.fromJson(data);

        // Update data dengan filter kondisi dan process image path
        namaAlat.value = alat.namaAlat ?? '';
        kodeQr.value = alat.kodeQr ?? '';
        lokasi.value = alat.lokasi ?? '';
        detailLokasi.value = alat.detailLokasi ?? '';
        kondisi.value = filterKondisiAlat(alat.kondisi ?? '');
        pestType.value = alat.pestType ?? '';

        // Process image path from API response
        final rawImagePath = alat.imagePath ?? '';
        imagePath.value = _processImagePath(rawImagePath);

        print('✅ Tool detail refreshed:');
        print('   Nama alat: ${alat.namaAlat}');
        print('   Kondisi original: ${alat.kondisi}');
        print('   Kondisi filtered: ${kondisi.value}');
        print('   Raw imagePath: $rawImagePath');
        print('   Processed imagePath: ${imagePath.value}');

        Get.snackbar(
          'Berhasil',
          'Data alat berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else {
        throw Exception('Failed to fetch data: ${response?.statusCode}');
      }
    } catch (e) {
      print('❌ Error refreshing tool detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memperbarui data alat: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void deleteTool(int id) async {
    print('🗑️ Mencoba menghapus alat dengan ID: $id');

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
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await AlatService.deleteAlat(id);
      print('📡 Delete response status: ${response?.statusCode}');
      print('📄 Delete response body: ${response?.body}');

      Get.back(); // Tutup loading dialog

      if (response != null && response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Alat "${namaAlat.value}" berhasil dihapus.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back to detail data page
        Get.offAllNamed('/detaildata');
      } else {
        final errorMessage = response?.statusCode != null
            ? 'Gagal menghapus alat. Status: ${response!.statusCode}'
            : 'Gagal menghapus alat. Tidak ada response dari server';

        Get.snackbar(
          'Gagal',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error saat menghapus alat: $e');
      Get.back(); // Tutup loading dialog jika masih terbuka
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghapus alat: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method untuk mendapatkan full image URL (untuk debugging)
  String getFullImageUrl() {
    return Config.getImageUrl(imagePath.value);
  }

  // Method untuk set loading state manual (jika diperlukan)
  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  // Method untuk load ulang data dengan loading state
  Future<void> loadToolDetail() async {
    await refreshToolDetail();
  }
}