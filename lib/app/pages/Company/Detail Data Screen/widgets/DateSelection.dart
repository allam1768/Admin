import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MonthSelection extends StatefulWidget {
  final Function(DateTime, DateTime) onMonthRangeChanged;

  const MonthSelection({super.key, required this.onMonthRangeChanged});

  @override
  _MonthSelectionState createState() => _MonthSelectionState();
}

class _MonthSelectionState extends State<MonthSelection> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Set initial start date to beginning of current month
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // Set initial end date to end of current month
    endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

    // Call the callback with initial dates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMonthRangeChanged(startDate, endDate);
    });
  }

  Future<void> _selectStartMonth(BuildContext context) async {
    final DateTime? picked = await _showMonthYearPicker(
      context: context,
      initialDate: startDate,
      title: 'Select Start Month',
    );

    if (picked != null) {
      setState(() {
        // Set to first day of selected month
        startDate = DateTime(picked.year, picked.month, 1);

        // If start date is after end date, adjust end date
        if (startDate.isAfter(endDate)) {
          endDate = DateTime(picked.year, picked.month + 1, 0); // Last day of same month
        }
      });
      widget.onMonthRangeChanged(startDate, endDate);
    }
  }

  Future<void> _selectEndMonth(BuildContext context) async {
    final DateTime? picked = await _showMonthYearPicker(
      context: context,
      initialDate: endDate,
      title: 'Select End Month',
      firstDate: startDate,
    );

    if (picked != null) {
      setState(() {
        // Set to last day of selected month
        endDate = DateTime(picked.year, picked.month + 1, 0);
      });
      widget.onMonthRangeChanged(startDate, endDate);
    }
  }

  Future<DateTime?> _showMonthYearPicker({
    required BuildContext context,
    required DateTime initialDate,
    required String title,
    DateTime? firstDate,
  }) async {
    DateTime selectedDate = initialDate;

    return showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Container(
                width: 300,
                height: 400,
                child: Column(
                  children: [
                    // Year Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(selectedDate.year - 1, selectedDate.month);
                            });
                          },
                          icon: Icon(Icons.keyboard_arrow_left),
                        ),
                        Text(
                          selectedDate.year.toString(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(selectedDate.year + 1, selectedDate.month);
                            });
                          },
                          icon: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Month Selection Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final month = index + 1;
                          final monthDate = DateTime(selectedDate.year, month);
                          final isSelected = selectedDate.month == month;

                          // Check if this month is disabled (before firstDate)
                          final isDisabled = firstDate != null &&
                              monthDate.isBefore(DateTime(firstDate.year, firstDate.month));

                          return GestureDetector(
                            onTap: isDisabled ? null : () {
                              setState(() {
                                selectedDate = DateTime(selectedDate.year, month);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.ijomuda
                                    : isDisabled
                                    ? Colors.grey.shade200
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.ijomuda
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat('MMM').format(DateTime(2024, month)),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : isDisabled
                                        ? Colors.grey.shade400
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedDate),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.ijomuda,
                  ),
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => _selectStartMonth(context),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20.w, color: AppColor.ijomuda),
                SizedBox(width: 8.w),
                Text(
                  DateFormat('MMM yyyy').format(startDate),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () => _selectEndMonth(context),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20.w, color: AppColor.ijomuda),
                SizedBox(width: 8.w),
                Text(
                  DateFormat('MMM yyyy').format(endDate),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}