import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin/values/app_color.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> data;
  final Color primaryColor;
  final String title;
  final bool isLoading;

  const LineChartWidget({
    Key? key,
    required this.data,
    required this.title,
    this.primaryColor = AppColor.btnoren,
    this.isLoading = false,
  }) : super(key: key);

  double get maxY {
    if (data.isEmpty) return 10;
    double max = data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    if (max == 0) return 10;
    return max < 10 ? 10 : max * 1.2;
  }

  double get maxX {
    if (data.isEmpty) return 5;
    double max = data.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
    return max == 0 ? 1 : max + 0.5;
  }

  bool get hasValidData {
    if (data.isEmpty) return false;
    if (data.length == 1 && data.first.x == 0 && data.first.y == 0) return false;
    bool allZero = data.every((spot) => spot.y == 0);
    return !allZero;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              if (isLoading) ...[
                SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ] else if (hasValidData) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Total: ${data.map((e) => e.y.toInt()).reduce((a, b) => a + b)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 250.h,
            child: isLoading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading chart data...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : !hasValidData
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 48.w,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Data will appear when catches are recorded',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: maxY > 10 ? maxY / 5 : 2,
                  verticalInterval: maxX > 1 ? 1 : 0.5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1.w,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1.w,
                  ),
                ),
                titlesData: FlTitlesData(
                leftTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
    ),


                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35.h,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int intValue = value.toInt();
                        if (value == intValue && intValue >= 0 && intValue < data.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              'Week ${intValue + 1}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: primaryColor,
                    barWidth: 3.w,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.3),
                          primaryColor.withOpacity(0.15),
                          primaryColor.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5.r,
                          color: primaryColor,
                          strokeWidth: 2.w,
                          strokeColor: Colors.white,
                        );
                      },
                    ),

                  ),
                ],
              ),
            ),
          ),
          if (hasValidData) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.w,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Showing ${data.length} data points for selected range',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}