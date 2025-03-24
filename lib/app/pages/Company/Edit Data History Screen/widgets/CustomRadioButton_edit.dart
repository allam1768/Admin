import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomRadioButtonGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final RxString selectedValue;
  final RxBool showError;

  const CustomRadioButtonGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.showError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Row(
          children: options
              .map(
                (option) => Obx(() => Row(
              children: [
                Radio(
                  value: option,
                  groupValue: selectedValue.value,
                  activeColor: const Color(0xFFFFA726),
                  onChanged: (value) {
                    selectedValue.value = value.toString();
                  },
                ),
                Text(
                  option,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:  Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )),
          )
              .toList(),
        ),
        Obx(() => showError.value && selectedValue.value.isEmpty
            ? Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Text(
            "$title harus dipilih!",
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
        )
            : SizedBox()),
      ],
    );
  }
}
