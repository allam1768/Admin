import 'dart:io';
import 'package:get/get.dart';

class CreateAccountClientController extends GetxController {
  var name = "".obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var showError = false.obs;
  var profileImage = Rx<File?>(null);

  void validateForm() {
    showError.value = name.value.isEmpty ||
        phoneNumber.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty ||
        password.value != confirmPassword.value;
  }
}
