import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String employeeNumber;
  final String date;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.employeeNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF97B999),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: Colors.grey.shade400,
            child: Icon(Icons.image, size: 32.sp, color: Colors.black54),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Text(employeeNumber, style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold)),
              SizedBox(height: 4.h),
              Text(date, style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
