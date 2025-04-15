import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String? rightIcon;
  final VoidCallback? rightOnTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.rightIcon,
    this.rightOnTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: SvgPicture.asset(
                  "assets/icons/back_btn.svg",
                  width: 36.w,
                  height: 36.h,
                ),
              ),
            ),
          if (showBackButton) SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
            ),
          ),
          if (rightIcon != null && rightOnTap != null)
            GestureDetector(
              onTap: rightOnTap,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: SvgPicture.asset(
                  rightIcon!,
                  width: 36.w,
                  height: 36.h,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
