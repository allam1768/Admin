import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global component/CustomButton.dart';
import 'qr_controller.dart';

class QrView extends StatelessWidget {
  final String qrData;
  QrView({super.key, required this.qrData});

  final QrController controller = Get.put(QrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        key: controller.globalKey,
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 250.w,
                                gapless: true,
                              ),
                              Container(
                                width: 60.w,
                                height: 60.w,
                                color: Color(0xFFD9D9D9),
                              ),
                              Image.asset(
                                "assets/images/logo.png",
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Column(
                  children: [
                    CustomButton(
                      text: "Save",
                      color: const Color(0xFFFFA726),
                      onPressed: controller.saveQrImage,
                      fontSize: 20.sp,
                    ),
                    SizedBox(height: 10.h),
                    CustomButton(
                      text: "Back to Dashboard",
                      color: const Color(0xFF275637),
                      onPressed: controller.goToDashboard,
                      fontSize: 20.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
