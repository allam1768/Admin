import 'package:get/get.dart';

class AccountClientController extends GetxController {
  final userName = "Wawan".obs;
  final userEmail = "abc@gmail.com".obs;
  final fullName = "Wawan Ajay Gimang".obs;
  final company = "Indofood".obs;
  final phoneNumber = "087788987208".obs;
  final password = "password123".obs;
  final profileImage = "https://example.com/profile.jpg".obs;

  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToEditAccount() {
    Get.offNamed('/EditAccountClient');
  }

  void deleteAccount() {
    print("Delete pressed");
  }
}
