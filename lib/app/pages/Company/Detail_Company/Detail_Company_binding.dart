import 'package:get/get.dart';
import 'Detail_Company_controller.dart';

class DetailCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailCompanyController());
  }
}
