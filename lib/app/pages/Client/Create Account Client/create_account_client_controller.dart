import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountClientController extends GetxController {
  final usernameController = TextEditingController();
  final nameCompanyController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var profileImage = Rx<File?>(null);
  var imageError = false.obs;
  var isPasswordHidden = true.obs;
  var usernameError = RxnString();
  var nameCompanyError = RxnString();
  var phoneError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();

  void validateForm() {
    final username = usernameController.text;
    final namecompany = nameCompanyController.text;
    final phone = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    usernameError.value = username.isEmpty ? "Username harus diisi!" : null;
    nameCompanyError.value =
        namecompany.isEmpty ? "Nama Company harus diisi!" : null;
    phoneError.value = phone.isEmpty ? "Phone number harus diisi!" : null;
    passwordError.value = password.isEmpty ? "Password harus diisi!" : null;

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Confirm Password harus diisi!";
    } else if (confirmPassword != password) {
      confirmPasswordError.value = "Password tidak cocok!";
    } else {
      confirmPasswordError.value = null;
    }

    // Optional, cuma untuk styling UI
    imageError.value = profileImage.value == null;

    // Validasi tanpa image
    if ([
      usernameError.value,
      nameCompanyError.value,
      phoneError.value,
      passwordError.value,
      confirmPasswordError.value,
    ].every((e) => e == null)) {
      print("✅ Data berhasil disimpan!");

      Get.toNamed('/CreateAccountCompany');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
      imageError.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    nameCompanyController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}
