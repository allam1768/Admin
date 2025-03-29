import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountClientController extends GetxController {
  var name = "".obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var showError = false.obs;
  var profileImage = Rx<File?>(null);

  void setName(String value) => name.value = value;
  void setPhoneNumber(String value) => phoneNumber.value = value;
  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;
  void setConfirmPassword(String value) => confirmPassword.value = value;

  void validateForm() {
    showError.value = true;

    if (name.value.isEmpty ||
        phoneNumber.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty ||
        password.value != confirmPassword.value) {
      return;
    }

    Get.toNamed('/CreateAccountCompany');
  }


  Widget showErrorMessage(String fieldName) {
    if (!showError.value) return SizedBox();

    String message = "";
    if (fieldName == "Name" && name.value.isEmpty) {
      message = "Name harus diisi!";
    } else if (fieldName == "Phone number" && phoneNumber.value.isEmpty) {
      message = "Phone number harus diisi!";
    } else if (fieldName == "Email" && email.value.isEmpty) {
      message = "Email harus diisi!";
    } else if (fieldName == "Password" && password.value.isEmpty) {
      message = "Password harus diisi!";
    } else if (fieldName == "Confirm Password" && confirmPassword.value.isEmpty) {
      message = "Confirm Password harus diisi!";
    } else if (fieldName == "Confirm Password" && password.value != confirmPassword.value) {
      message = "Password tidak cocok!";
    }

    return message.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(message, style: TextStyle(fontSize: 12, color: Colors.red)),
    )
        : SizedBox();
  }
}
