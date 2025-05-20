import 'package:admin/app/pages/Company/tools/Edit%20Tools/update_qr_tools_controller.dart';
import 'package:get/get.dart';

class EditToolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditToolController>(() => EditToolController());
  }
}
