import 'package:admin/app/pages/Company/Qr%20Company%20Screen/qr_company_controller.dart';
import 'package:get/get.dart';

class QrCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrCompanyController>(() => QrCompanyController());
  }
}
