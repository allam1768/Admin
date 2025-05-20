import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../../../../global component/CustomAppBar.dart';
import '../../../../global component/CustomButton.dart';
import '../../../../global component/CustomTextField.dart';
import '../../../../global component/ImageUpload.dart';
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
            CustomAppBar(
              title: "Create Qr",
              onBackTap: () => Get.toNamed('/detaildata'),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/input_illustration.svg',
                          width: 310.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => CustomTextField(
                                label: "Name",
                                onChanged: (value) =>
                                    controller.name.value = value,
                                errorMessage: controller.nameError.value,
                                showErrorBorder: controller.showError.value,
                              )),
                          SizedBox(height: 15.h),
                          Obx(() => CustomTextField(
                                label: "Lokasi",
                                onChanged: (value) =>
                                    controller.area.value = value,
                                errorMessage: controller.areaError.value,
                                showErrorBorder: controller.showError.value,
                              )),
                          SizedBox(height: 15.h),
                          Obx(() => CustomTextField(
                                label: "Detail lokasi",
                                onChanged: (value) =>
                                    controller.detail.value = value,
                                errorMessage: controller.detailError.value,
                                showErrorBorder: controller.showError.value,
                              )),
                          SizedBox(height: 15.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Obx(() => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: controller.showError.value &&
                                                    controller.selectedType
                                                            .value ==
                                                        null
                                                ? Colors.red
                                                : Color(0xFF275637),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          value: controller.selectedType.value,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 14.h,
                                              horizontal: 8.w,
                                            ),
                                            isDense: true,
                                          ),
                                          hint: Text(
                                            "Pilih tipe...",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.grey),
                                          ),
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black),
                                          icon: Icon(Icons.arrow_drop_down),
                                          onChanged: (value) {
                                            controller.selectedType.value =
                                                value;
                                            controller.showError.value = false;
                                          },
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Land',
                                              child: Text('Darat'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Flying',
                                              child: Text('Terbang'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (controller.showError.value &&
                                          controller.selectedType.value == null)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.h, left: 4.w),
                                          child: Text(
                                            "Type harus dipilih!",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.red),
                                          ),
                                        ),
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          ImageUpload(
                            imageFile: controller.imageFile,
                            imageError: controller.imageError,
                          ),
                          SizedBox(height: 50.h),
                          Obx(() {
                            return CustomButton(
                              text: controller.isLoading.value
                                  ? "Loading..."
                                  : "Create Qr",
                              backgroundColor: AppColor.btnoren,
                              onPressed: () {
                                controller.validateForm();
                              },
                              fontSize: 20,
                            );
                          }),
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
