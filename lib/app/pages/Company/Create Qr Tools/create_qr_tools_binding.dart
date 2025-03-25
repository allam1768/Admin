import 'package:get/get.dart';
import 'create_qr_tools_controller.dart';

class CreateQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateQrController>(() => CreateQrController());
  }
}
