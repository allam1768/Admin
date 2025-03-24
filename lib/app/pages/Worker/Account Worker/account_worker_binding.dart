import 'package:get/get.dart';
import 'account_worker_controller.dart';

class AccountWorkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountWorkerController());
  }
}
