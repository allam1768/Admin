import 'package:admin/app/pages/Company/tools/Qr%20Detail%20Tool%20Screen/qr_detail_tool_controller.dart';
import 'package:get/get.dart';

class QrDetailToolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrDetailToolController>(() => QrDetailToolController());
  }
}
