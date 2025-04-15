import 'package:get/get.dart';
import 'create_qr_tools_controller.dart';

class CreateQrToolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateQrToolController>(() => CreateQrToolController());
  }
}
