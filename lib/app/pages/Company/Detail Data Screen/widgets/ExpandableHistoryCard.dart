import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'SingleHistoryCard.dart';

class ExpandableHistoryCard extends StatelessWidget {
  final String imagePath;
  final String location;
  final List<Map<String, dynamic>> historyItems;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableHistoryCard({
    super.key,
    required this.imagePath,
    required this.location,
    required this.historyItems,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomLeft: isExpanded ? Radius.zero : Radius.circular(12.r),
              bottomRight: isExpanded ? Radius.zero : Radius.circular(12.r),
            ),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: 372.w,
                  height: 180.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12.w,
                  bottom: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Container(
            decoration: BoxDecoration(
              color: AppColor.backgroundsetengah,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                ...historyItems.map((item) => SingleHistoryCard(item: item)).toList(),
                SizedBox(height: 8.h),
              ],
            ),
          )
              : const SizedBox(),
        ),
      ],
    );
  }
}
