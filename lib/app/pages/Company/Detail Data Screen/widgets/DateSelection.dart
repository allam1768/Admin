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

  Future<void> _selectStartMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.ijomuda,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = DateTime(picked.year, picked.month);
        if (startDate.isAfter(endDate)) {
          endDate = DateTime(picked.year, picked.month);
        }
      });
      widget.onMonthRangeChanged(startDate, endDate);
    }
  }

  Future<void> _selectEndMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.ijomuda,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        endDate = DateTime(picked.year, picked.month);
      });
      widget.onMonthRangeChanged(startDate, endDate);
    }
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
