import 'package:get/get.dart';

import 'edit_account_worker_controller.dart';

class EditAccountWorkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAccountWorkerController>(() => EditAccountWorkerController());
  }
}
