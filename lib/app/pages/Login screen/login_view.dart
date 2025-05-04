import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../global component/CustomButton.dart';
import '../../global component/CustomTextField.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Please Sign in to continue.",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),

                // Username
                CustomTextField(
                  hintText: 'Username',
                  svgIcon: 'assets/icons/username.svg',
                  controller: controller.nameController,
                ),
                SizedBox(height: 16.h),

                CustomTextField(
                  hintText: "Password",
                  svgIcon: 'assets/icons/password.svg',
                  controller: controller.passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 12.h),

                Obx(() => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Center(
                        child: Text(
                          controller.loginError.value.isNotEmpty
                              ? controller.loginError.value
                              : ' ',
                          style: TextStyle(
                            color: controller.loginError.value.isNotEmpty
                                ? Colors.red
                                : Colors.transparent,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )),

                // Button Login
                Obx(() => CustomButton(
                      text:
                          controller.isLoading.value ? 'Loading...' : 'Sign In',
                      onPressed:
                           controller.login,
                      backgroundColor: AppColor.btnoren,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
