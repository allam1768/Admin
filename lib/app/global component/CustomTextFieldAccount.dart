import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'CustomTextField.dart';

class CustomTextFieldAccount extends StatelessWidget {
  final String label;
  final RxString value;
  final bool isPassword;
  final bool isNumber;
  final String? Function()? errorMessage;

  const CustomTextFieldAccount({
    super.key,
    required this.label,
    required this.value,
    this.isPassword = false,
    this.isNumber = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: label,
          isPassword: isPassword,
          isNumber: isNumber,
          onChanged: (val) => value.value = val,
        ),
        Obx(() {
          final error = errorMessage?.call();
          return error != null ? _errorText(error) : SizedBox();
        }),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _errorText(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Text(
        message,
        style: TextStyle(fontSize: 14.sp, color: Colors.red),
      ),
    );
  }
}
