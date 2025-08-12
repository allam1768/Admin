import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Bottom Nav/bottomnav_controller.dart';

class CreateAccountClientController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var profileImage = Rx<File?>(null);
  var imageError = false.obs;

  var nameError = RxnString();
  var emailError = RxnString();
  var phoneError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();

  var isLoading = false.obs;

  void validateForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Reset error messages
    nameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    // Validate name
    if (name.isEmpty) {
      nameError.value = "Name harus diisi!";
    } else if (name.length < 2) {
      nameError.value = "Name minimal 2 karakter!";
    }

    // Validate email
    if (email.isEmpty) {
      emailError.value = "Email harus diisi!";
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Format email tidak valid!";
    }

    // Validate phone
    if (phone.isEmpty) {
      phoneError.value = "Phone number harus diisi!";
    } else if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(phone)) {
      phoneError.value = "Format phone number tidak valid!";
    }

    // Validate password
    if (password.isEmpty) {
      passwordError.value = "Password harus diisi!";
    } else if (password.length < 6) {
      passwordError.value = "Password minimal 6 karakter!";
    }

    // Validate confirm password
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Confirm Password harus diisi!";
    } else if (confirmPassword != password) {
      confirmPasswordError.value = "Password tidak cocok!";
    }

    // Jika semua valid → pindah screen dengan arguments
    if ([
      nameError.value,
      emailError.value,
      phoneError.value,
      passwordError.value,
      confirmPasswordError.value,
    ].every((error) => error == null)) {
      goToNextScreen();
    }
  }

  void goToNextScreen() {
    Get.toNamed(
      '/CreateQrCompany',
      arguments: {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text,
        "profileImage": profileImage.value,
      },
    );
  }

  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 1;
    Get.offNamed('/bottomnav');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
