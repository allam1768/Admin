import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../values/app_color.dart';
import '../../../global component/CustomButton.dart';
import 'qr_detail_company_controller.dart';

class QrDetailCompanyView extends StatelessWidget {
  final String qrData;
  QrDetailCompanyView({super.key, required this.qrData});

  final QrDetailCompanyController controller = Get.put(QrDetailCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
                                width: 40.w,
                                height: 40.w,
                                color: Color(0xFFD9D9D9),
                              ),
                              Image.asset(
                                "assets/images/logo.png",
                                width: 30.w,
                                height: 30.w,
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
                      backgroundColor: AppColor.btnoren,
                      onPressed: controller.saveQrImage,
                      fontSize: 20.sp,
                    ),
                    SizedBox(height: 10.h),
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
