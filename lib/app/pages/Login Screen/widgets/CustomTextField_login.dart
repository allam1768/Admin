import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFieldLogin extends StatelessWidget {
  final String hintText;
  final String iconPath;
  final bool isPassword;
  final bool isPasswordHidden;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;

  const CustomTextFieldLogin({
    super.key,
    required this.hintText,
    required this.iconPath,
    this.isPassword = false,
    this.isPasswordHidden = true,
    this.onSuffixTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isPasswordHidden : false,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
            ),
          ),
          suffixIcon: isPassword
              ? GestureDetector(
            onTap: onSuffixTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SvgPicture.asset(
                isPasswordHidden ? 'assets/icons/eye_closed.svg' : 'assets/icons/eye_open.svg',
                width: 20.w,
                height: 20.h,
              ),
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Color(0xFF275637), width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Color(0xFF275637), width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Color(0xFF275637), width: 2.w),
          ),
        ),
      ),
    );
  }
}
