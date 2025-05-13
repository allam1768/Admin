import 'package:get/get.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class DetailToolController extends GetxController {
  final namaAlat = "".obs;
  final kodeQr = "".obs;
  final lokasi = "".obs;
  final detailLokasi = "".obs;
  final kondisi = "".obs;
  final pestType = "".obs;
  final imagePath = "".obs;

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
    super.onInit();
  }

  void goToEditTool() {
    Get.offNamed('/EditTool');
  }

  void deleteTool() {
    Get.find<BottomNavController>().selectedIndex.value = 1;
    Get.offNamed('/bottomnav');
  }
}
