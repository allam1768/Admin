import 'package:get/get.dart';

class AccountWorkerController extends GetxController {
  final userName = "Wawan".obs;
  final userEmail = "abc@gmail.com".obs;
  final fullName = "Wawan Ajay Gimang".obs;
  final phoneNumber = "087788987208".obs;
  final password = "**********".obs;

  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Update data akun
  void updateAccount({
    required String name,
    required String email,
    required String fullName,
    required String phone,
  }) {
    userName.value = name;
    userEmail.value = email;
    this.fullName.value = fullName;
    phoneNumber.value = phone;
  }

  void deleteAccount() {
    print("Delete pressed");
  }

  void navigateToEditAccount() {
    Get.toNamed('/EditAccountWorker');
  }
}
