import 'package:get/get.dart';
import 'data_company_controller.dart';

class DataCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataCompanyController>(() => DataCompanyController());
  }
}
