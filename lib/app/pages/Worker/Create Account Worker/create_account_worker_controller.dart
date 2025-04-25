import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Bottom Nav/bottomnav_controller.dart';

class CreateAccountWorkerController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var profileImage = Rx<File?>(null);
  var imageError = false.obs;

  var nameError = RxnString();
  var phoneError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();



  void validateForm() {
    final name = nameController.text;
    final phone = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    nameError.value = name.isEmpty ? "Name harus diisi!" : null;
    phoneError.value = phone.isEmpty ? "Phone number harus diisi!" : null;
    passwordError.value = password.isEmpty ? "Password harus diisi!" : null;

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Confirm Password harus diisi!";
    } else if (confirmPassword != password) {
      confirmPasswordError.value = "Password tidak cocok!";
    } else {
      confirmPasswordError.value = null;
    }

    imageError.value = profileImage.value == null;

    if ([
      nameError.value,
      phoneError.value,
      passwordError.value,
      confirmPasswordError.value,
    ].every((e) => e == null)) {
      // Gambar profil tidak wajib diisi
      print("✅ Data berhasil disimpan!");

      // Navigasi ke halaman yang sesuai
      Get.find<BottomNavController>().selectedIndex.value = 2;
      Get.offNamed('/bottomnav');
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
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
