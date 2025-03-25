import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'SummaryCard.dart';

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
    double size = 82.w < 82.h ? 82.w : 82.h; // Pastikan ukuran selalu kotak

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF9CB1A3), // Warna latar belakang diperbarui
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SummaryCard(title: "Total alat", value: totalAlat.toString()),
          SummaryCard(title: "Pengecekan", value: totalPengecekan.toString()),
          GestureDetector(
            onTap: onQrTap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/qr_icont.svg", // Ganti dengan path icon QR
                  width: 50.w,
                  height: 50.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
