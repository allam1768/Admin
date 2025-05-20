import 'package:get/get.dart';
import 'Detail_Tool_controller.dart';

class DetailToolBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailToolController());
  }
}
