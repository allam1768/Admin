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
  final String kode_qr;
  final String pest_type;
  final List<Map<String, dynamic>> historyItems;

  const ToolCard({
    super.key,
    required this.toolName,
    required this.imagePath,
    required this.location,
    required this.locationDetail,
    required this.historyItems,
    required this.kondisi,
    required this.kode_qr,
    required this.pest_type,
  });

  @override
  Widget build(BuildContext context) {
    String normalized = kondisi.trim().toLowerCase();
    Color statusColor = normalized == 'good' ? AppColor.btnijo : AppColor.oren;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => Get.toNamed('/historytool', arguments: {
            'toolName': toolName,
          }),
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
                            'assets/images/broken.png',
                            width: double.infinity,
                            height: 180.h,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    // Status kondisi (bulat)
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
                    // Nama alat
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
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
                // Lokasi, detail & kondisi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            locationDetail,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            kondisi.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            size: 20.sp,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {
                            Get.toNamed('/detailtool', arguments: {
                              'toolName': toolName,
                              'imagePath': imagePath,
                              'location': location,
                              'locationDetail': locationDetail,
                              'kondisi': kondisi,
                              'kodeQR': kode_qr,
                              'type': pest_type,
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
