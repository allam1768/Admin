import 'package:admin/pages/Login%20Screen/widgets/CustomButton_login.dart';
import 'package:admin/pages/Login%20Screen/widgets/CustomTextField_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              CustomTextFieldLogin(
                hintText: "Username",
                iconPath: "assets/icons/username.svg",
              ),
              SizedBox(height: 16.h),
              CustomTextFieldLogin(
                hintText: "Password",
                iconPath: "assets/icons/password.svg",
                isPassword: true,
              ),
              SizedBox(height: 56.h),

              CustomButtonLogin(
                text: "Sign In",
                onPressed: () {
                  Get.offNamed('/bottomnav');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
