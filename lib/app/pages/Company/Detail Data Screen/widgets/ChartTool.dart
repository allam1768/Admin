import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'ChartLineTool.dart';

class ChartTool extends StatefulWidget {
  final String title;
  final List<List<FlSpot>> chartData; // Multiple layers of data
  final Function(String) onNoteChanged;
  final VoidCallback onSave;
  final List<Color> colors; // Colors for each layer
  final List<String>? labels; // Optional labels for legend

  const ChartTool({
    Key? key,
    required this.title,
    required this.chartData,
    required this.onNoteChanged,
    required this.onSave,
    required this.colors,
    this.labels,
  }) : super(key: key);

  @override
  _ChartToolState createState() => _ChartToolState();
}

class _ChartToolState extends State<ChartTool> {
  final TextEditingController _noteController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildLegend() {
    if (widget.labels == null || widget.labels!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: List.generate(
              widget.labels!.length,
                  (index) {
                if (index >= widget.colors.length) return SizedBox.shrink();

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: widget.colors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      widget.labels![index],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    if (widget.chartData.isEmpty || widget.labels == null) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          ...List.generate(
            widget.labels!.length,
                (index) {
              if (index >= widget.chartData.length || index >= widget.colors.length) {
                return SizedBox.shrink();
              }

              List<FlSpot> data = widget.chartData[index];
              int total = 0;
              if (data.isNotEmpty && !(data.length == 1 && data.first.y == 0)) {
                total = data.map((e) => e.y.toInt()).reduce((a, b) => a + b);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: widget.colors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          widget.labels![index],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$total catches',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: widget.colors[index],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total for display
    int totalCatches = 0;
    for (var dataSet in widget.chartData) {
      if (dataSet.isNotEmpty && !(dataSet.length == 1 && dataSet.first.y == 0)) {
        totalCatches += dataSet.map((e) => e.y.toInt()).reduce((a, b) => a + b);
      }
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and total
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                if (totalCatches > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: widget.colors.isNotEmpty
                          ? widget.colors.first.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$totalCatches total',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.colors.isNotEmpty
                            ? widget.colors.first
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Chart Section
          LineChartToolWidget(
            allData: widget.chartData,
            title: widget.title,
            primaryColors: widget.colors,
            isLoading: false,
          ),

          // Legend Section (if labels provided)
          if (widget.labels != null && widget.labels!.isNotEmpty)
            _buildLegend(),

          // Expandable Statistics Section
          if (widget.labels != null && widget.labels!.isNotEmpty)
            Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detailed Statistics',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                          size: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isExpanded)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: _buildStatistics(),
                  ),
              ],
            ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}