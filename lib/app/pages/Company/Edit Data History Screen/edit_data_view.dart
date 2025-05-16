import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageUpload.dart';
import 'edit_data_controller.dart';

class EditDataHistoryView extends StatelessWidget {
  EditDataHistoryView({super.key});

  final EditDataHistoryController controller = Get.put(EditDataHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Edit Data",
              onBackTap: () => Get.toNamed('/detailhistory'),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 250.h,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/input_illustration.svg',
                        width: 310.w,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      width: double.infinity,
                      child: Text(
                        "Fly 01 Utara",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      color: AppColor.backgroundsetengah,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Condition",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 6.w),
                                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                                      decoration: BoxDecoration(
                                        color: controller.selectedCondition.value == "Baik"
                                            ? AppColor.oren.withOpacity(0.08)
                                            : Colors.white,
                                        border: Border.all(
                                          color: controller.showError.value && controller.selectedCondition.value.isEmpty
                                              ? Colors.red
                                              : (controller.selectedCondition.value == "Baik"
                                              ? AppColor.oren
                                              : Colors.grey.shade300),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: "Baik",
                                            groupValue: controller.selectedCondition.value,
                                            onChanged: controller.setCondition,
                                            activeColor: AppColor.oren,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "Baik",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 6.w),
                                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                                      decoration: BoxDecoration(
                                        color: controller.selectedCondition.value == "Rusak"
                                            ? AppColor.oren.withOpacity(0.08)
                                            : Colors.white,
                                        border: Border.all(
                                          color: controller.showError.value && controller.selectedCondition.value.isEmpty
                                              ? Colors.red
                                              : (controller.selectedCondition.value == "Rusak"
                                              ? AppColor.oren
                                              : Colors.grey.shade300),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: "Rusak",
                                            groupValue: controller.selectedCondition.value,
                                            onChanged: controller.setCondition,
                                            activeColor: AppColor.oren,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "Rusak",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Error message
                              if (controller.showError.value && controller.selectedCondition.value.isEmpty)
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w, top: 6.h),
                                  child: Text(
                                    "Kondisi harus dipilih!",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          )),

                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Amount",
                            isNumber: true,
                            onChanged: controller.setAmount,
                            errorMessage: controller.showError.value && controller.amount.value.isEmpty
                                ? "Amount harus diisi!"
                                : null,
                          )),
                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Information",
                            onChanged: controller.setInformation,
                            errorMessage: controller.showError.value && controller.information.value.isEmpty
                                ? "Information harus diisi!"
                                : null,
                          )),
                          SizedBox(height: 15.h),


                          ImageUpload(
                            imageFile: controller.imageFile,
                            imageError: controller.imageError,
                          ),
                          SizedBox(height: 20.h),

                          CustomButton(
                            text: "Save",
                            backgroundColor:AppColor.btnijo,
                            onPressed: controller.validateForm,
                            fontSize: 16,
                          ),

                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
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
