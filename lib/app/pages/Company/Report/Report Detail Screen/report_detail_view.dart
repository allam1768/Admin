import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../values/app_color.dart';
import '../../../../global component/CustomAppBar.dart';
import '../../../../global component/CustomTextField.dart';
import 'Widgets/ImagePreview.dart';
import 'report_detail_controller.dart';

class ReportDetailView extends StatelessWidget {
  final ReportDetailController controller = Get.put(ReportDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: "Report Detail", onBackTap: ()=>Get.back(),),
                SizedBox(height: 22.h),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/report_illustration.svg",
                    width: 250.w,
                    height: 212.h,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.backgroundsetengah,
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 35.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Area",
                      onChanged: (value) => controller.setArea(value),
                    ),
                    SizedBox(height: 15.h),

                    CustomTextField(
                      label: "Information",
                      onChanged: (value) => controller.setInformation(value),
                    ),
                    SizedBox(height: 15.h),

                    Text(
                      "Documentation",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),

                    GestureDetector(
                      onTap: () {
                        ImagePreview(context, "assets/images/example.png");
                      },
                      child: Container(
                        width: double.infinity,
                        height: 204.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Icon(Icons.image,
                              color: Colors.white, size: 50.w),
                        ),
                      ),
                    ),

                    SizedBox(height: 22.h), // Jarak dari bawah layar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
