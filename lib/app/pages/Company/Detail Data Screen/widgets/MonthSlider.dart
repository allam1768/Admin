import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthSlider extends StatefulWidget {
  final Function(int) onMonthChanged;

  const MonthSlider({super.key, required this.onMonthChanged});

  @override
  _MonthSliderState createState() => _MonthSliderState();
}

class _MonthSliderState extends State<MonthSlider> {
  final PageController _monthController = PageController(initialPage: 0);
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  int selectedMonth = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Color(0xFF9CB1A3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              if (selectedMonth > 0) {
                setState(() {
                  selectedMonth--;
                });
                _monthController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                widget.onMonthChanged(selectedMonth);
              }
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: _monthController,
              itemCount: months.length,
              onPageChanged: (index) {
                setState(() {
                  selectedMonth = index;
                });
                widget.onMonthChanged(selectedMonth);
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    months[index],
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.black),
            onPressed: () {
              if (selectedMonth < months.length - 1) {
                setState(() {
                  selectedMonth++;
                });
                _monthController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                widget.onMonthChanged(selectedMonth);
              }
            },
          ),
        ],
      ),
    );
  }
}
