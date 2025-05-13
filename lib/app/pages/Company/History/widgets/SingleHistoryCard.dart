import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';

class SingleHistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const SingleHistoryCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Card(
        elevation: 2,  // Memberikan bayangan halus untuk kedalaman
        shadowColor: Colors.black.withOpacity(0.1),  // Shadow lebih soft
        color: AppColor.backgroundsetengah,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => Get.toNamed('/detailhistory'),
          child: SizedBox(
            height: 84.h,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${item["date"]}   ${item["time"]}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
