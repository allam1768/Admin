import 'package:admin/values/app_color.dart';
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
    double size = 82.w < 82.h ? 82.w : 82.h;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                color: AppColor.btnoren,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/qr_icont.svg",
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
