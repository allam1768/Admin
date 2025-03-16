import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<FlSpot> dataPoints;
  final Function(String) onNoteChanged;
  final Color? color; // Warna bisa diubah

  const DataCard({
    super.key,
    required this.title,
    required this.dataPoints,
    required this.onNoteChanged,
    this.color, // Parameter opsional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF00A88B), // Default kalau warna nggak diisi
        borderRadius: BorderRadius.circular(20.r),
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
              // Grafik Garis
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
                                radius: 4.r,
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

              // Keterangan di Samping
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
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              onChanged: onNoteChanged,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Tambah catatan...",
                hintStyle: TextStyle(fontSize: 14.sp),
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0),
                  child: SvgPicture.asset(
                    "assets/icons/note_icont.svg",
                    width: 24.r,
                    height: 24.r,
                  ),
                ),
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
