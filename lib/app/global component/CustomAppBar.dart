import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String? rightIcon;
  final VoidCallback? rightOnTap;
  final bool showBackButton;
  final VoidCallback onBackTap; // Wajib

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackTap, // Wajib
    this.rightIcon,
    this.rightOnTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBackTap,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
                child: SvgPicture.asset(
                  "assets/icons/back_btn.svg",
                  width: MediaQuery.of(context).size.width * 0.09,
                  height: MediaQuery.of(context).size.width * 0.09,
                ),
              ),
            ),
          if (showBackButton)
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (rightIcon != null && rightOnTap != null)
            GestureDetector(
              onTap: rightOnTap,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
                child: SvgPicture.asset(
                  rightIcon!,
                  width: MediaQuery.of(context).size.width * 0.09,
                  height: MediaQuery.of(context).size.width * 0.09,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
