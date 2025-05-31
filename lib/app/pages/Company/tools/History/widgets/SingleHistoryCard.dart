import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../values/app_color.dart';

class SingleHistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const SingleHistoryCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              // Pass the catch data to detail page
              Get.toNamed('/detailhistory', arguments: item);
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: _getStatusColor(item["kondisi"]),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tool name and pest type
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item["name"] ?? "Unknown Tool",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),

                        // Pest info
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.bug_report_outlined,
                        //       size: 14.sp,
                        //       color: Colors.black54,
                        //     ),
                        //     SizedBox(width: 4.w),
                        //     Text(
                        //       "${item['jenis_hama']} (${item['jumlah']})",
                        //       style: TextStyle(
                        //         fontSize: 13.sp,
                        //         color: Colors.black87,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //     SizedBox(width: 8.w),
                        //     Container(
                        //       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        //       decoration: BoxDecoration(
                        //         color: _getStatusColor(item["kondisi"]).withOpacity(0.1),
                        //         borderRadius: BorderRadius.circular(4.r),
                        //       ),
                        //       child: Text(
                        //         item["kondisi"].toString().toUpperCase(),
                        //         style: TextStyle(
                        //           fontSize: 10.sp,
                        //           color: _getStatusColor(item["kondisi"]),
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 6.h),

                        // Date, time and recorded by
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12.sp,
                              color: Colors.black45,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${item["date"]} at ${item["time"]}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 12.sp,
                              color: Colors.black45,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Recorded by ${item['dicatat_oleh']}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColor.ijomuda.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: AppColor.ijomuda,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'broken':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return AppColor.ijomuda;
    }
  }
}