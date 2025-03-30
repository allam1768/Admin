import 'package:admin/app/global%20component/CustomButton.dart';
import 'package:admin/app/global%20component/ImageUpload.dart';
import 'package:admin/app/pages/Company/Create%20Qr%20Company/Widget/ImageCompany.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/app_bar.dart';
import 'create_qr_company_controller.dart';

class CreateQrCompanyView extends StatelessWidget {
  CreateQrCompanyView({super.key});

  final CreateQrCompanyController controller = Get.put(CreateQrCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Create Company"),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: 250.h,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/company_ilustration.svg',
                          width: 310.w,
                        ),
                      ),
                    ),

                    Container(
                      color: const Color(0xFFBBD4C3),
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageCompany(
                            imageFile: controller.imageFile,
                            imageError: controller.imageError,
                          ),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Name Company",
                            onChanged: (value) => controller.name.value = value,
                          ),
                          Obx(() => controller.showErrorMessage("Name Company")),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Address Company",
                            onChanged: (value) => controller.address.value = value,
                          ),
                          Obx(() => controller.showErrorMessage("Address Company")),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Phone number",
                            isNumber: true,
                            onChanged: (value) => controller.phoneNumber.value = value,
                          ),
                          Obx(() => controller.showErrorMessage("Phone number")),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Email Company",
                            onChanged: (value) => controller.email.value = value,
                          ),
                          Obx(() => controller.showErrorMessage("Email Company")),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Industry",
                            onChanged: (value) => controller.industry.value = value,
                          ),
                          Obx(() => controller.showErrorMessage("Industry")),
                          SizedBox(height: 40.h),

                          CustomButton(
                            text: "Create Qr",
                            color: const Color(0xFF275637),
                            onPressed: controller.validateForm,
                            fontSize: 16,
                          ),
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
