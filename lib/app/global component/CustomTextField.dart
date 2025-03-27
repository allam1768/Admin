import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final bool isNumber;
  final Function(String)? onChanged;
  final String? svgIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.isNumber = false,
    this.onChanged,
    this.svgIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        TextField(
          obscureText: widget.isPassword ? _isObscured : false,
          maxLines: widget.isPassword ? 1 : null,
          keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(fontSize: 15.sp),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: widget.svgIcon != null
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SvgPicture.asset(widget.svgIcon!, width: 20.r, height: 20.r),
            )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: SvgPicture.asset(
                _isObscured ? 'assets/icons/eye_closed.svg' : 'assets/icons/eye_open.svg',
                width: 20.r,
                height: 20.r,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
