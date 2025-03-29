import 'package:admin/app/pages/Company/Qr%20Tool%20Screen/qr_tool_controller.dart';
import 'package:get/get.dart';

class QrToolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrToolController>(() => QrToolController());
  }
}
