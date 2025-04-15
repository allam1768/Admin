import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageUpload.dart';
import 'create_qr_tools_controller.dart';

class CreateQrToolView extends StatelessWidget {
  CreateQrToolView({super.key});

  final CreateQrToolController controller = Get.put(CreateQrToolController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Create Qr"),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: 250.h,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/input_illustration.svg',
                          width: 310.w,
                        ),
                      ),
                    ),

                    Container(
                      color: AppColor.backgroundsetengah,
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() =>CustomTextField(
                            label: "Name",
                            onChanged: (value) => controller.name.value = value,
                            errorMessage: controller.nameError.value,
                            showErrorBorder: controller.showError.value,
                            )),
                          SizedBox(height: 15.h),

                          Obx(() =>CustomTextField(
                            label: "Area",
                            onChanged: (value) => controller.area.value = value,
                            errorMessage: controller.areaError.value,
                            showErrorBorder: controller.showError.value,
                          )),
                          SizedBox(height: 15.h),


                          Text(
                            "Type",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5.h),

                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: controller.showError.value && controller.selectedType.value == null
                                        ? Colors.red
                                        : const Color(0xFF275637),
                                  ),
                                ),
                                child: DropdownMenu<String>(
                                  enableSearch: false,
                                  onSelected: (value) => controller.selectedType.value = value,
                                  width: double.infinity,
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(value: 'Darat', label: 'Darat'),
                                    DropdownMenuEntry(value: 'Terbang', label: 'Terbang'),
                                  ],
                                ),
                              ),
                              if (controller.showError.value && controller.selectedType.value == null)
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Text(
                                    "Type harus dipilih!",
                                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                                  ),
                                ),
                            ],
                          )),

                          SizedBox(height: 15.h),

                          ImageUpload(
                            imageFile: controller.imageFile,
                            imageError: controller.imageError,
                          ),

                          SizedBox(height: 20.h),

                          CustomButton(
                            text: "Create Qr",
                            backgroundColor:AppColor.btnijo,
                            onPressed: () {
                              controller.validateForm();
                            },
                            fontSize: 20,
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
