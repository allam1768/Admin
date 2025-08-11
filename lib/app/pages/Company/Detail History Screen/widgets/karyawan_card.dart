import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../values/app_color.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String employeeNumber;
  final String date; // ini diisi GMT/UTC dari controller

  const EmployeeCard({
    super.key,
    required this.name,
    required this.employeeNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 14.sp, color: Colors.grey.shade600),
                    SizedBox(width: 4.w),
                    Text(
                      convertGmtToWib(date), // langsung convert di sini
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk convert GMT/UTC ke WIB
  String convertGmtToWib(String gmtDateTime) {
    try {
      DateTime utcTime = DateTime.parse(gmtDateTime).toUtc();
      DateTime wibTime = utcTime.add(const Duration(hours: 7));

      return "${wibTime.day.toString().padLeft(2, '0')}-"
          "${wibTime.month.toString().padLeft(2, '0')}-"
          "${wibTime.year} ${wibTime.hour.toString().padLeft(2, '0')}:"
          "${wibTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return gmtDateTime; // fallback kalau format salah
    }
  }
}
