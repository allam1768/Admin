import 'package:flutter/material.dart';

class CustomButtonEdit extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Ubah ke nullable
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double height;

  const CustomButtonEdit({
    super.key,
    required this.text,
    required this.onPressed, // Tetap required tapi nullable
    this.backgroundColor = const Color(0xFF234E35), // default hijau
    this.textColor = Colors.black, // default putih
    this.fontSize = 30, // default 16sp
    this.height = 48, // default 48.h
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height * MediaQuery.of(context).size.height * 0.0012,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
          ),
        ),
        onPressed: onPressed, // ElevatedButton sudah support nullable
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize * MediaQuery.of(context).textScaleFactor,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}