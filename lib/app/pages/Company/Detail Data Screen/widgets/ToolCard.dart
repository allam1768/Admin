import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ToolCard extends StatelessWidget {
  final String toolName;
  final String imagePath;
  final String location;
  final String locationDetail;
  final String kondisi;
  final String kodeQR;
  final String type;
  final List<Map<String, dynamic>> historyItems;


  const ToolCard({
    super.key,
    required this.toolName,
    required this.imagePath,
    required this.location,
    required this.locationDetail,
    required this.historyItems,
    required this.kondisi,
    required this.kodeQR,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String normalized = kondisi.trim().toLowerCase();
    Color statusColor = normalized == 'good' ? Colors.green : Colors.red;

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
                'toolName': toolName,
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
                        child: Image.network(
                          imagePath,
                          width: double.infinity,
                          height: 180.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/broken.png', // fallback image lokal
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                            );
                          },
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
                            'toolName': toolName,
                            'imagePath': imagePath,
                            'location': location,
                            'locationDetail': locationDetail,
                            'historyItems': historyItems,
                            'kondisi': kondisi,
                            'kodeQr': kodeQR,
                            'pestType': type,
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
