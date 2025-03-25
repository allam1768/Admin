import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../global component/CustomTextField.dart';
import 'ChartLine.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> dataPoints;
  final Function(String) onNoteChanged;
  final VoidCallback onSave;
  final Color? color;

  const DataCard({
    super.key,
    required this.title,
    required this.dataPoints,
    required this.onNoteChanged,
    required this.onSave,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF97B999),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          Text(
            title,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),

          LineChartWidget(
            data: [
              FlSpot(1, 300),
              FlSpot(2, 4),
              FlSpot(3, 6),
              FlSpot(4, 8),
            ],
            primaryColor: Colors.blue,
          ),

          SizedBox(height: 20.h),

          CustomTextField(
            label: "Catatan",
            svgIcon: "assets/icons/note_icont.svg",
            onChanged: onNoteChanged,
          ),

          SizedBox(height: 12.h),

          // Tombol Save di Bawah
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                backgroundColor: Color(0xFFFFA726),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save_rounded, color: Colors.black, size: 18.r),
                  SizedBox(width: 6.w),
                  Text(
                    "Save",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
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
