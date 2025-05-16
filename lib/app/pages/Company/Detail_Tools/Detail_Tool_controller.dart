import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/alat_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

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
    final args = Get.arguments;
    namaAlat.value = args['toolName'] ?? '';
    kodeQr.value = args['kodeQr'] ?? '';
    lokasi.value = args['location'] ?? '';
    detailLokasi.value = args['locationDetail'] ?? '';
    kondisi.value = args['kondisi'] ?? '';
    pestType.value = args['pestType'] ?? '';
    imagePath.value = args['imagePath'] ?? 'assets/images/broken.png';
    id.value = args['id'] ?? 0;
    super.onInit();
  }

  void goToEditTool() {
    Get.offNamed('/EditTool');
  }

  void deleteTool(int id) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final response = await AlatService.deleteAlat(id);

    Get.back(); // Tutup loading dialog

    if (response != null && response.statusCode == 200) {
      Get.snackbar(
        'Berhasil',
        'Alat berhasil dihapus.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Arahkan ke tab ke-1 di BottomNav dan buka '/bottomnav'
      Get.find<BottomNavController>().selectedIndex.value = 1;
      Get.offAllNamed('/bottomnav');
    } else {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat menghapus alat.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
