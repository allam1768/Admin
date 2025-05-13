import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButtonDetail extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final String? svgIcon;
  final IconData? icon;

  const CustomButtonDetail({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.svgIcon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.025)),
        ),
        icon: svgIcon != null
            ? SvgPicture.asset(svgIcon!,
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.width * 0.05,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn))
            : icon != null
                ? Icon(icon, color: Colors.white)
                : const SizedBox.shrink(),
        label: Text(text,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                color: Colors.white)),
      ),
    );
  }
}
