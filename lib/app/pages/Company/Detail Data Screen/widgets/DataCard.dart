import 'package:admin/values/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

import '../../../../global component/CustomTextField.dart';
import 'ChartLine.dart';

class DataCard extends StatefulWidget {
  final String title;
  final List<FlSpot> chartData;
  final Function(String) onNoteChanged;
  final VoidCallback onSave;
  final Color? color;

  const DataCard({
    super.key,
    required this.title,
    required this.chartData,
    required this.onNoteChanged,
    required this.onSave,
    this.color,
  });

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  final TextEditingController _noteController = TextEditingController();
  String? _errorText;
  bool _noteTouched = false;

  void _handleSave() {
    final note = _noteController.text.trim();

    if (_noteTouched && note.isEmpty) {
      setState(() {
        _errorText = "Catatan tidak boleh dikosongkan setelah diisi";
      });
    } else {
      setState(() {
        _errorText = null;
      });
      widget.onNoteChanged(note); // tetap kirim meski kosong
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(18.w),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 20.h),
              LineChartWidget(
                data: widget.chartData,
                primaryColor: Colors.blue,
                title: 'asdada',
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                label: "Catatan",
                hintText: "isi catatan di sini",
                svgIcon: "assets/icons/note_icont.svg",
                controller: _noteController,
                errorMessage: _errorText,
                onChanged: (value) {
                  if (!_noteTouched && value.trim().isNotEmpty) {
                    _noteTouched = true;
                  }

                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    backgroundColor: AppColor.btnoren,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          Icons.save_rounded,
                          color: Colors.black87,
                          size: 18.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
