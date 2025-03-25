import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onChanged;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          hint: Text(
            widget.title,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
          ),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, size: 24.w),
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            widget.onChanged(value!);
          },
          items: widget.items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 16.sp),
            ),
          ))
              .toList(),
        ),
      ),
    );
  }
}
