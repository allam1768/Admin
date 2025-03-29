import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/ImageProfile.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/app_bar.dart';
import 'create_account_client_controller.dart';

class CreateAccountClientView extends StatelessWidget {
  CreateAccountClientView({super.key});

  final controller = Get.put(CreateAccountClientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Create Client"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    ImageProfile(profileImage: controller.profileImage),
                    SizedBox(height: 20.h),

                      Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 200.h, // Dynamic Height
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBBD4C3),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(label: "Name", onChanged: controller.setName),
                          Obx(() => controller.showErrorMessage("Name")),
                          SizedBox(height: 15.h),

                          CustomTextField(label: "Phone number", isNumber: true, onChanged: controller.setPhoneNumber),
                          Obx(() => controller.showErrorMessage("Phone number")),
                          SizedBox(height: 15.h),

                          CustomTextField(label: "Email", onChanged: controller.setEmail),
                          Obx(() => controller.showErrorMessage("Email")),
                          SizedBox(height: 15.h),

                          CustomTextField(label: "Password", isPassword: true, onChanged: controller.setPassword),
                          Obx(() => controller.showErrorMessage("Password")),
                          SizedBox(height: 15.h),

                          CustomTextField(label: "Confirm Password", isPassword: true, onChanged: controller.setConfirmPassword),
                          Obx(() => controller.showErrorMessage("Confirm Password")),
                          SizedBox(height: 40.h),

                          CustomButton(
                            text: "Create Qr Company",
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
