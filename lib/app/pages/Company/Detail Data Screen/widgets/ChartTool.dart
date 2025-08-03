import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'ChartLineTool.dart';

class ChartTool extends StatefulWidget {
  final String title;
  final List<List<FlSpot>> chartData;
  final Function(String) onNoteChanged;
  final VoidCallback onSave;
  final List<Color> colors;

  const ChartTool({
    Key? key,
    required this.title,
    required this.chartData,
    required this.onNoteChanged,
    required this.onSave,
    required this.colors,
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

  @override
  Widget build(BuildContext context) {
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
          // Chart Section
          LineChartToolWidget(
            allData: widget.chartData,
            title: widget.title,
            primaryColors: widget.colors,
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
