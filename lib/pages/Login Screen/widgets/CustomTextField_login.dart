import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFieldLogin extends StatefulWidget {
  final String hintText;
  final String iconPath;
  final bool isPassword;

  const CustomTextFieldLogin({
    super.key,
    required this.hintText,
    required this.iconPath,
    this.isPassword = false,
  });

  @override
  State<CustomTextFieldLogin> createState() => _CustomTextFieldLoginState();
}

class _CustomTextFieldLoginState extends State<CustomTextFieldLogin> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextField(
        obscureText: widget.isPassword ? isObscured : false,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              widget.iconPath,
              width: 24.w,
              height: 24.h,
            ),
          ),
          suffixIcon: widget.isPassword
              ? Padding(
            padding: EdgeInsets.only(right: 26.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isObscured = !isObscured;
                });
              },
              child: SvgPicture.asset(
                isObscured ? 'assets/icons/eye_closed.svg' : 'assets/icons/eye_open.svg',
                width: 20.w,
                height: 20.h,

              ),
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.transparent, width: 1.w),
          ),
        ),
      ),
    );
  }
}
