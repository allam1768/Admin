import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SingleHistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const SingleHistoryCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Card(
        color: const Color(0xFFBBD4C3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            Get.toNamed('/detailhistory');
          },
          child: SizedBox(
            height: 84.h,
            width: double.infinity,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              title: Text(
                "Pengecekan",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${item["date"]} | Jumlah: ${item["count"] ?? 0}",
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
