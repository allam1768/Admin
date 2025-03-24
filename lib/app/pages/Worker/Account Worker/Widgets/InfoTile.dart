import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isPassword;
  final VoidCallback? onTogglePassword;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.isPassword = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: Color(0xFF9BBB9C),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black, size: 20.sp),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPassword && onTogglePassword != null) ...[
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: onTogglePassword,
                        child: Icon(
                          value == "********" ? Icons.visibility : Icons.visibility_off,
                          size: 18.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
