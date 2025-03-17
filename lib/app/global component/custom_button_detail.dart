import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButtonDetail extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final String? svgIcon;
  final IconData? icon;

  const CustomButtonDetail({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.svgIcon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        icon: svgIcon != null
            ? SvgPicture.asset(svgIcon!, width: 20.w, height: 20.h, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn))
            : icon != null
            ? Icon(icon, color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(text, style: TextStyle(fontSize: 18.sp, color: Colors.white)),
      ),
    );
  }
}
