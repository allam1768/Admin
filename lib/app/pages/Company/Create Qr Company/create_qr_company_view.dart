import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageUpload.dart';
import 'create_qr_company_controller.dart';

class CreateQrCompanyView extends StatelessWidget {
  CreateQrCompanyView({super.key});

  final CreateQrCompanyController controller = Get.put(CreateQrCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Create Company",
              onBackTap: () => Get.toNamed('/CreateAccountClient'),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/company_ilustration.svg',
                          width: 310.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageUpload(
                            imageFile: controller.imageFile,
                            showButton: false,
                          ),
                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Name Company",
                            onChanged: (value) => controller.name.value = value,
                            errorMessage: controller.nameError.value.isNotEmpty ? controller.nameError.value : null,
                          )),
                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Address Company",
                            onChanged: (value) => controller.address.value = value,
                            errorMessage: controller.addressError.value.isNotEmpty ? controller.addressError.value : null,
                          )),
                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Phone number",
                            isNumber: true,
                            onChanged: (value) => controller.phoneNumber.value = value,
                            errorMessage: controller.phoneError.value.isNotEmpty ? controller.phoneError.value : null,
                          )),
                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Email Company",
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => controller.email.value = value,
                            errorMessage: controller.emailError.value.isNotEmpty ? controller.emailError.value : null,
                          )),
                          SizedBox(height: 40.h),

                          Obx(() => CustomButton(
                            text: controller.isLoading.value ? "Creating..." : "Create Qr",
                            backgroundColor: AppColor.btnoren,
                            onPressed: controller.isLoading.value ? () {} : controller.validateForm,
                            fontSize: 16,
                          )),
                          SizedBox(height: 20.h),
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