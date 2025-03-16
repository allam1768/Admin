import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82.w,
      height: 82.h,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  final int totalAlat;
  final int totalPengecekan;
  final VoidCallback onQrTap;

  const SummarySection({
    super.key,
    required this.totalAlat,
    required this.totalPengecekan,
    required this.onQrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFF97B999), // Warna latar belakang diperbarui
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SummaryCard(title: "Total alat", value: totalAlat.toString()),
          SummaryCard(title: "Pengecekan", value: totalPengecekan.toString()),
          GestureDetector(
            onTap: onQrTap,
            child: Container(
              width: 82.w,
              height: 82.h,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/qr_icont.svg", // Ganti dengan path icon QR
                  width: 48.w,
                  height: 48.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
