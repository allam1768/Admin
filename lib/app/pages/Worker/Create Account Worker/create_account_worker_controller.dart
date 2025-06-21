import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/services/worker_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class CreateAccountWorkerController extends GetxController {
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
  var errorMessage = RxnString();

  final WorkerService _workerService = WorkerService();

  void validateForm() {
    final name = nameController.text;
    final email = emailController.text;
    final phone = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    nameError.value = name.isEmpty ? "Name harus diisi!" : null;

    if (email.isEmpty) {
      emailError.value = "Email harus diisi!";
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Format email tidak valid!";
    } else {
      emailError.value = null;
    }

    phoneError.value = phone.isEmpty ? "Phone number harus diisi!" : null;
    passwordError.value = password.isEmpty ? "Password harus diisi!" : null;

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Confirm Password harus diisi!";
    } else if (confirmPassword != password) {
      confirmPasswordError.value = "Password tidak cocok!";
    } else {
      confirmPasswordError.value = null;
    }

    // Gambar profil tidak wajib diisi
    // imageError.value = profileImage.value == null;

    if ([
      nameError.value,
      emailError.value,
      phoneError.value,
      passwordError.value,
      confirmPasswordError.value,
    ].every((e) => e == null)) {
      createWorker();
    }
  }

  Future<void> createWorker() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await _workerService.createWorker(
        name: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        password: passwordController.text,
        profileImage: profileImage.value,
      );

      if (response.success) {
        Get.snackbar(
          'Sukses',
          'Akun worker berhasil dibuat',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Navigasi ke halaman yang sesuai
        Get.find<BottomNavController>().selectedIndex.value = 2;
        Get.offNamed('/bottomnav');
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Gagal',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat membuat akun',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
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
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 2;
    Get.offNamed(
        '/bottomnav'); // Ganti dengan nama screen yang ada bottom nav-nya
  }
}
