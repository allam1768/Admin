import 'package:admin/app/pages/Company/Qr%20Screen/qr_controller.dart';
import 'package:get/get.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrController>(() => QrController());
  }
}
