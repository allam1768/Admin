import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final bool isPassword;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.isPassword = false,
    this.onChanged,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isEmpty = false;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();

    // Cek apakah initialValue diberikan, jika iya gunakan itu
    if (widget.initialValue != null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      _controller = TextEditingController();
    }

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isEmpty = _controller.text.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Text(
            widget.label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword,
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
            maxLines: widget.isPassword ? 1 : null,
            keyboardType: widget.isPassword ? TextInputType.text : TextInputType.multiline,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.5.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.w,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _isEmpty = value.isEmpty;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
