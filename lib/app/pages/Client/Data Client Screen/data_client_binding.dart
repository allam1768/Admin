import 'package:admin/app/pages/Client/Data%20Client%20Screen/data_client_controller.dart';
import 'package:get/get.dart';

class DataClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataClientController>(() => DataClientController());
  }
}
