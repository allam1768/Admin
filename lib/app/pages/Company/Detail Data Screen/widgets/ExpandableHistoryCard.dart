import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExpandableHistoryCard extends StatelessWidget {
  final String toolName;
  final String imagePath;
  final String location;
  final String locationDetail;
  final List<Map<String, dynamic>> historyItems;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableHistoryCard({
    super.key,
    required this.toolName,
    required this.imagePath,
    required this.location,
    required this.locationDetail,
    required this.historyItems,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String kondisi = historyItems.isNotEmpty ? historyItems.first['kondisi'] ?? '' : '';
    Color statusColor = kondisi.toLowerCase() == 'baik' ? Colors.green : Colors.red;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.btomnav,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed('/historytool', arguments: {
                'location': location,
                'imagePath': imagePath,
                'historyItems': historyItems,
              });
            },
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          imagePath,
                          width: double.infinity,
                          height: 180.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Lingkaran status kondisi di kanan atas
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,

                          ),
                        ),
                      ),

                      // Nama alat di atas gambar
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            toolName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Lokasi dan more icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            locationDetail,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/detailtool', arguments: {
                            'locationDetail': locationDetail,
                            'location': location,
                          });
                        },
                        child: Icon(Icons.more_vert, size: 24.sp, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
