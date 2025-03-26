import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final Function(String)? onChanged;
  final String? svgIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.onChanged,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        TextField(
          obscureText: isPassword,
          style: TextStyle(fontSize: 15.sp),
          minLines: 1, // Awal hanya 1 baris
          maxLines: null, // Bisa bertambah sesuai teks
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: svgIcon != null
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SvgPicture.asset(svgIcon!, width: 20.r, height: 20.r),
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
