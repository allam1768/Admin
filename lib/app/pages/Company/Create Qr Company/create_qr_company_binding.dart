import 'package:admin/app/pages/Company/Create%20Qr%20Company/create_qr_company_controller.dart';
import 'package:get/get.dart';

class CreateQrCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateQrCompanyController>(() => CreateQrCompanyController());
  }
}
