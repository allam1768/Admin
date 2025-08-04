import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineChartToolWidget extends StatefulWidget {
  final List<List<FlSpot>> allData; // Multiple layers of data
  final String title;
  final List<Color> primaryColors; // Colors for each layer
  final bool isLoading;

  const LineChartToolWidget({
    Key? key,
    required this.allData,
    required this.title,
    required this.primaryColors,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<LineChartToolWidget> createState() => _LineChartToolWidgetState();
}

class _LineChartToolWidgetState extends State<LineChartToolWidget> {
  List<int> showingTooltipOnSpots = [];

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        height: 200.h,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.allData.isEmpty || widget.allData.every((data) => data.isEmpty)) {
      return Container(
        height: 200.h,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 250.h,
      padding: EdgeInsets.all(16.w),
      child: LineChart(
        _buildLineChartData(),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    // Calculate min/max values across all datasets
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = 0;
    double maxY = double.negativeInfinity;

    for (var dataSet in widget.allData) {
      if (dataSet.isNotEmpty) {
        for (var spot in dataSet) {
          if (spot.x < minX) minX = spot.x;
          if (spot.x > maxX) maxX = spot.x;
          if (spot.y > maxY) maxY = spot.y;
        }
      }
    }

    // Handle edge cases
    if (minX == double.infinity) minX = 0;
    if (maxX == double.negativeInfinity) maxX = 1;
    if (maxY == double.negativeInfinity) maxY = 10;

    // Add some padding to max values
    maxY = maxY * 1.1;
    if (maxY == 0) maxY = 10;

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.8),
          tooltipRoundedRadius: 8.r,
          tooltipPadding: EdgeInsets.all(8.w),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              final color = widget.primaryColors.length > touchedSpot.barIndex
                  ? widget.primaryColors[touchedSpot.barIndex]
                  : Colors.grey;

              return LineTooltipItem(
                '${touchedSpot.y.toInt()}',
                TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30.h,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value < 0 || value >= (maxX - minX + 1)) {
                return Text('');
              }

              // Simple day numbering
              return Text(
                '${value.toInt() + 1}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.sp,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40.w,
            interval: maxY / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.sp,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: _buildLineBarsData(),
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    List<LineChartBarData> lineBars = [];

    for (int i = 0; i < widget.allData.length; i++) {
      final dataSet = widget.allData[i];
      final color = i < widget.primaryColors.length
          ? widget.primaryColors[i]
          : Colors.grey;

      // Skip empty datasets or datasets with only zero values
      if (dataSet.isEmpty || (dataSet.length == 1 && dataSet.first.y == 0)) {
        continue;
      }

      lineBars.add(
        LineChartBarData(
          spots: dataSet,
          isCurved: true,
          color: color,
          barWidth: 3.w,
          isStrokeCapRound: true,
          curveSmoothness: 0.3,
          preventCurveOverShooting: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4.w,
                color: color,
                strokeWidth: 2.w,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: color.withOpacity(0.1),
          ),
          shadow: Shadow(
            blurRadius: 8,
            color: color.withOpacity(0.2),
            offset: Offset(0, 2),
          ),
        ),
      );
    }

    // If no valid data, show a placeholder line
    if (lineBars.isEmpty) {
      lineBars.add(
        LineChartBarData(
          spots: [FlSpot(0, 0), FlSpot(1, 0)],
          isCurved: false,
          color: Colors.grey.shade400,
          barWidth: 1.w,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return lineBars;
  }
}