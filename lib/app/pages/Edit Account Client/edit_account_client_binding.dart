import 'package:get/get.dart';

import 'edit_account_client_controller.dart';

class EditAccountClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAccountClientController>(() => EditAccountClientController());
  }
}
