import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'ChartLine.dart';

class DataCard extends StatefulWidget {
  final String title;
  final List<FlSpot> chartData;
  final Function(String) onNoteChanged;
  final VoidCallback onSave;
  final Color color;

  const DataCard({
    Key? key,
    required this.title,
    required this.chartData,
    required this.onNoteChanged,
    required this.onSave,
    required this.color,
  }) : super(key: key);

  @override
  _DataCardState createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  final TextEditingController _noteController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug info

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
          LineChartWidget(
            data: widget.chartData,
            title: widget.title,
            primaryColor: widget.color,
            isLoading: false, // You can pass loading state from controller if needed
          ),

          // Expandable Notes Section
          Container(
            width: double.infinity,
            child: Column(
              children: [
                // Expand/Collapse Button
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 20.w,
                          color: widget.color,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Add Notes',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 24.w,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Notes Input Section
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isExpanded ? null : 0,
                  child: _isExpanded
                      ? Container(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes for ${widget.title}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add your observations or notes here...',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: widget.color,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(16.w),
                          ),
                          onChanged: widget.onNoteChanged,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.onSave();
                                  Get.snackbar(
                                    "Success",
                                    "Notes for ${widget.title} saved successfully!",
                                    backgroundColor: widget.color.withOpacity(0.1),
                                    colorText: widget.color,
                                    duration: Duration(seconds: 2),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.color,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'Save Notes',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            OutlinedButton(
                              onPressed: () {
                                _noteController.clear();
                                widget.onNoteChanged('');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: widget.color,
                                side: BorderSide(color: widget.color),
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}