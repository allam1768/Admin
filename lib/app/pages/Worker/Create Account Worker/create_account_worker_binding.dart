import 'package:get/get.dart';
import 'create_account_worker_controller.dart';

class CreateAccountWorkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountWorkerController>(() => CreateAccountWorkerController());
  }
}
