import 'package:get/get.dart';
import 'account_client_controller.dart';

class AccountClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountClientController());
  }
}
