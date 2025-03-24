import 'package:admin/app/global%20component/CustomButton.dart';
import 'package:admin/app/pages/Company/Edit%20Data%20History%20Screen/widgets/CustomRadioButton_edit.dart';
import 'package:admin/app/pages/Company/Edit%20Data%20History%20Screen/widgets/ImageUpload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/app_bar.dart';
import 'edit_data_controller.dart';

class EditDataHistoryView extends StatelessWidget {
  EditDataHistoryView({super.key});

  final EditDataHistoryController controller = Get.put(EditDataHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Edit Data"),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: 250.h,
                      color: const Color(0xFFCCD7CD),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/input_illustration.svg',
                          width: 310.w,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      color: const Color(0xFFCCD7CD),
                      child: Text(
                        "Fly 01 Utara",
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      color: const Color(0xFFBBD4C3),
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomRadioButtonGroup(
                            title: "Condition",
                            options: ["Baik", "Rusak"],
                            selectedValue: controller.selectedCondition,
                            showError: controller.showError,
                          ),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Amount",
                            onChanged: (value) => controller.amount.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.amount.value.isEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Amount harus diisi!",
                              style: TextStyle(fontSize: 14.sp, color: Colors.red),
                            ),
                          )
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Information",
                            onChanged: (value) => controller.information.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.information.value.isEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Information harus diisi!",
                              style: TextStyle(fontSize: 14.sp, color: Colors.red),
                            ),
                          )
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          ImageUploadComponent(),
                          SizedBox(height: 20.h),

                          CustomButton(
                            text: "Save",
                            color: Color(0xFF275637),
                            onPressed: () {
                              controller.validateForm();
                            },
                            fontSize: 20,
                          ),

                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
