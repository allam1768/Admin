import 'dart:io';
import 'package:get/get.dart';

class EditAccountWorkerController extends GetxController {
  var name = "".obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var showError = false.obs;
  var profileImage = Rx<File?>(null);

  void validateForm() {
    showError.value = true;
  }

  bool hasError(String field) {
    if (!showError.value) return false;

    switch (field) {
      case "Name":
        return name.value.isEmpty;
      case "Phone number":
        return phoneNumber.value.isEmpty;
      case "Email":
        return email.value.isEmpty;
      case "Password":
        return password.value.isEmpty;
      case "Confirm Password":
        return confirmPassword.value.isEmpty || password.value != confirmPassword.value;
      default:
        return false;
    }
  }

  String? getErrorMessage(String field) {
    if (!hasError(field)) return null;

    if (field == "Confirm Password" && password.value != confirmPassword.value) {
      return "Password tidak cocok!";
    }
    return "$field harus diisi!";
  }
}
