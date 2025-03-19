import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<FlSpot> dataPoints;
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
          SizedBox(height: 54.h),

          // Diagram + Keterangan di Samping
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 175.h,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: dataPoints
                              .map((e) => FlSpot(e.x, e.y.toInt().toDouble()))
                              .toList(),
                          isCurved: false,
                          barWidth: 2.w,
                          color: Colors.black,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 3.r,
                                color: Colors.black,
                                strokeWidth: 0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoItem("Total",
                      dataPoints.map((e) => e.y.toInt()).reduce((a, b) => a + b).toString()),
                  _infoItem("Max",
                      dataPoints.map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b).toString()),
                  _infoItem("Min",
                      dataPoints.map((e) => e.y.toInt()).reduce((a, b) => a < b ? a : b).toString()),
                ],
              ),
            ],
          ),
          SizedBox(height: 42.h),

          // Input Catatan
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              onChanged: onNoteChanged,
              minLines: 1,
              maxLines: 5,
              style: TextStyle(fontSize: 14.sp),
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Tambah catatan...",
                hintStyle: TextStyle(fontSize: 14.sp),
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(
                    "assets/icons/note_icont.svg",
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h), // Jarak antara TextField & tombol

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
                    style: TextStyle(fontSize: 14.sp, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            "$label:",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(width: 4.w),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
