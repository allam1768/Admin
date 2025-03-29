import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final bool isNumber;
  final Function(String)? onChanged;
  final String? svgIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.isNumber = false,
    this.onChanged,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isObscured = ValueNotifier<bool>(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        ValueListenableBuilder<bool>(
          valueListenable: isObscured,
          builder: (context, obscured, _) {
            return TextField(
              obscureText: isPassword ? obscured : false,
              maxLines: isPassword ? 1 : null,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: svgIcon != null
                    ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: SvgPicture.asset(svgIcon!, width: 20.r, height: 20.r),
                )
                    : null,
                suffixIcon: isPassword
                    ? IconButton(
                  icon: SvgPicture.asset(
                    obscured ? 'assets/icons/eye_closed.svg' : 'assets/icons/eye_open.svg',
                    width: 20.r,
                    height: 20.r,
                  ),
                  onPressed: () {
                    isObscured.value = !obscured;
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
