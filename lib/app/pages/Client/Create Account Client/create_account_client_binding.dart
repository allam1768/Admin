import 'package:get/get.dart';
import 'create_account_client_controller.dart';

class CreateAccountClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountClientController>(() => CreateAccountClientController());
  }
}
