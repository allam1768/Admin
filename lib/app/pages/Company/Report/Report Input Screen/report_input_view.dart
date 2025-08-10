import 'package:admin/app/pages/Company/Edit%20Data%20History%20Screen/widgets/CustomButtonEdit.dart';
import 'package:admin/app/pages/Company/Report/Report%20Input%20Screen/report_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../values/app_color.dart';
import '../../../../global component/CustomAppBar.dart';
import '../../../../global component/ImageUpload.dart';
import '../../Edit Data History Screen/widgets/CustomTextFieldEdit.dart';


class ReportInputView extends StatelessWidget {
  ReportInputView({super.key});

  final ReportInputController controller = Get.put(ReportInputController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(title: "Report", onBackTap: () => Get.back(),),
                SizedBox(height: 22.h),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/report_illustration.svg',
                    width: 200.w,
                    height: 212.h,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: AppColor.backgroundsetengah,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Area TextField with debugging
                      Obx(() {
                        print("🔄 Area field rebuilding - Value: '${controller.amount.value}', Error: '${controller.areaError.value}'");
                        return CustomTextFieldEdit(
                          label: "Area",
                          onChanged: (value) {
                            controller.amount.value = value;
                          },
                          errorMessage: controller.areaError,
                        );
                      }),
                      SizedBox(height: 15.h),

                      // Information TextField with debugging
                      Obx(() {
                        print("🔄 Information field rebuilding - Value: '${controller.information.value}', Error: '${controller.informationError.value}'");
                        return CustomTextFieldEdit(
                          label: "Information",
                          onChanged: (value) {
                            controller.information.value = value;
                          },
                          errorMessage: controller.informationError,
                        );
                      }),
                      SizedBox(height: 15.h),

                      // Image Upload with debugging
                      Obx(() {
                        print("🔄 ImageUpload rebuilding - Has image: ${controller.imageFile.value != null}, Error: ${controller.imageError.value}");
                        return ImageUpload(
                          imageFile: controller.imageFile,
                          imageError: controller.imageError,
                        );
                      }),
                      SizedBox(height: 20.h),

                      // Submit Button with debugging
                      Obx(() {
                        bool isLoading = controller.isLoading.value;
                        print("🔄 Submit button rebuilding - Loading: $isLoading");

                        return CustomButtonEdit(
                          text: isLoading ? "Menyimpan..." : "Save",
                          backgroundColor: isLoading
                              ? AppColor.btnoren.withOpacity(0.6)
                              : AppColor.btnoren,
                          onPressed: isLoading
                              ? null
                              : () {

                            controller.validateForm();
                          },
                          fontSize: 16,
                        );
                      }),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay with debugging
            Obx(() {
              bool showLoading = controller.isLoading.value;
              print("🔄 Loading overlay rebuilding - Show: $showLoading");

              return showLoading
                  ? Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColor.btnijo,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Mengirim laporan...",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}