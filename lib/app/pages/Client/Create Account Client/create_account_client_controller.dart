import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/services/client_service.dart';
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
  var errorMessage = RxnString();
  var successMessage = RxnString();

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
    errorMessage.value = null;

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
    } else if (phone.length < 10) {
      phoneError.value = "Phone number minimal 10 digit!";
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

    // Check if all validations passed
    if ([
      nameError.value,
      emailError.value,
      phoneError.value,
      passwordError.value,
      confirmPasswordError.value,
    ].every((error) => error == null)) {
      createClient();
    }
  }

  // Function to save client data to SharedPreferences
  Future<void> _saveClientData({
    required String clientId,
    required String name,
    required String email,
    String? token,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('client_id', clientId);
      await prefs.setString('client_name', name);
      await prefs.setString('client_email', email);

      if (token != null && token.isNotEmpty) {
        await prefs.setString('auth_token', token);
      }

      print('Client data saved successfully');
      print('Client ID: $clientId');
      print('Client Name: $name');
      print('Client Email: $email');
    } catch (e) {
      print('Error saving client data: $e');
    }
  }

  Future<void> createClient() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      successMessage.value = null;

      final response = await ClientService.createClient(
        username: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text,
        profileImage: profileImage.value,
      );

      if (response.success) {
        // Store success message
        successMessage.value = response.message;

        // Save client data to SharedPreferences
        if (response.user != null) {
          await _saveClientData(
            clientId: response.user!.id.toString(),
            name: response.user!.name,
            email: response.user!.email ?? '',
            token: response.token,
          );
        }

        // Show success snackbar with detailed info
        Get.snackbar(
          'Sukses',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );

        // Log the created user data and token
        if (response.user != null) {
          print('User created successfully:');
          print('ID: ${response.user!.id}');
          print('Name: ${response.user!.name}');
          print('Role: ${response.user!.role}');
          if (response.token != null) {
            print('Token: ${response.token}');
          }
        }

        // Clear form after successful creation
        _clearForm();

        // Delay before navigation to allow user to see success message
        await Future.delayed(Duration(seconds: 1));

        Get.toNamed('/CreateQrCompany');

      } else {
        // Handle error response
        errorMessage.value = response.message;

        Get.snackbar(
          'Gagal',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      print('Error creating client: $e');
      errorMessage.value = 'Terjadi kesalahan saat menghubungi server';

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat membuat akun: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        profileImage.value = File(picked.path);
        imageError.value = false;

        Get.snackbar(
          'Sukses',
          'Gambar profil berhasil dipilih',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    }
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    profileImage.value = null;

    // Clear error messages
    nameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    errorMessage.value = null;
    successMessage.value = null;
  }

  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 1;
    Get.offNamed('/bottomnav');
  }

  // Method untuk retry jika terjadi error
  void retryCreateClient() {
    if (!isLoading.value) {
      validateForm();
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
}