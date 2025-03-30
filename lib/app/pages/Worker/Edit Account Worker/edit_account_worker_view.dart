import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global component/CustomButton.dart';
import '../../../global component/ImageProfile.dart';
import '../../../global component/app_bar.dart';
import '../../../global component/CustomTextFieldAccount.dart';
import 'edit_account_worker_controller.dart';

class EditAccountWorkerView extends StatelessWidget {
  EditAccountWorkerView({super.key});

  final EditAccountWorkerController controller = Get.put(EditAccountWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Edit Worker"),
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
                        minHeight: MediaQuery.of(context).size.height - 180.h, // Sesuaikan dengan tinggi layar
                      ),
                      color: const Color(0xFFBBD4C3),
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFieldAccount(
                            label: "Name",
                            value: controller.name,
                            errorMessage: () => controller.getErrorMessage("Name"),
                          ),
                          CustomTextFieldAccount(
                            label: "Phone number",
                            value: controller.phoneNumber,
                            isNumber: true,
                            errorMessage: () => controller.getErrorMessage("Phone number"),
                          ),
                          CustomTextFieldAccount(
                            label: "Email",
                            value: controller.email,
                            errorMessage: () => controller.getErrorMessage("Email"),
                          ),
                          CustomTextFieldAccount(
                            label: "Password",
                            value: controller.password,
                            isPassword: true,
                            errorMessage: () => controller.getErrorMessage("Password"),
                          ),
                          CustomTextFieldAccount(
                            label: "Confirm Password",
                            value: controller.confirmPassword,
                            isPassword: true,
                            errorMessage: () => controller.getErrorMessage("Confirm Password"),
                          ),
                          SizedBox(height: 20.h),
                          CustomButton(
                            text: "Save",
                            color: const Color(0xFF275637),
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
