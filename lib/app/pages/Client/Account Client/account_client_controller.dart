import 'package:get/get.dart';

class AccountClientController extends GetxController {
  // Data user
  final userName = "Wawan".obs;
  final userEmail = "abc@gmail.com".obs;
  final fullName = "Wawan Ajay Gimang".obs;
  final company = "Indofood".obs;
  final phoneNumber = "087788987208".obs;
  final password = "**********".obs;

  // Status visibilitas password
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
