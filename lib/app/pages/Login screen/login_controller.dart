import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;
  var usernameError = "".obs;
  var passwordError = "".obs;
  var loginError = "".obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Reset semua error
    usernameError.value = "";
    passwordError.value = "";
    loginError.value = "";

    if (username.isEmpty || password.isEmpty) {
      loginError.value = "Username atau password salah";
      return;
    }

    if (username == "admin" && password == "admin123") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offNamed('/bottomnav');
    } else {
      loginError.value = "Username atau password salah";
    }
  }

}
