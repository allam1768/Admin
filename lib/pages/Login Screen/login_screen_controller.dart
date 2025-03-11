import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}
