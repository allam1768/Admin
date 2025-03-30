import 'package:admin/app/pages/Login%20Screen/widgets/CustomButton_login.dart';
import 'package:admin/app/pages/Login%20Screen/widgets/CustomTextField_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'login_screen_controller.dart';

class LoginScreenView extends StatelessWidget {
  LoginScreenView({super.key});

  final LoginScreenController controller = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/login_illustration.svg',
                    width: 310.w,
                  ),
                ),
                SizedBox(height: 130.h),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Please Sign in to continue.",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 24.h),

                // Username Input
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldLogin(
                      hintText: "Username",
                      iconPath: "assets/icons/username.svg",
                      controller: controller.usernameController,
                    ),
                    if (controller.usernameError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 8.w),
                        child: Text(
                          controller.usernameError.value,
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        ),
                      ),
                  ],
                )),
                SizedBox(height: 16.h),

                // Password Input
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldLogin(
                      hintText: "Password",
                      iconPath: "assets/icons/password.svg",
                      isPassword: true,
                      isPasswordHidden: controller.isPasswordHidden.value,
                      onSuffixTap: controller.togglePasswordVisibility,
                      controller: controller.passwordController,
                    ),
                    if (controller.passwordError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 8.w),
                        child: Text(
                          controller.passwordError.value,
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        ),
                      ),
                  ],
                )),
                SizedBox(height: 16.h),

                // Error Login
                Obx(() {
                  if (controller.loginError.value.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Center(
                        child: Text(
                          controller.loginError.value,
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),

                // Tombol Login
                Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : CustomButtonLogin(
                  text: "Sign In",
                  onPressed: controller.login,
                )),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
