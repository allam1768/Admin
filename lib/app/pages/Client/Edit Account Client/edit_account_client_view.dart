import 'package:admin/app/global%20component/CustomTextFieldAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/ImageProfile.dart';
import '../../../global component/app_bar.dart';
import 'edit_account_client_controller.dart';

class EditAccountClientView extends StatelessWidget {
  EditAccountClientView({super.key});

  final EditAccountClientController controller = Get.put(EditAccountClientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Edit Client"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    ImageProfile(profileImage: controller.profileImage),
                    SizedBox(height: 20.h),
                    Container(
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
                            label: "Name Company",
                            value: controller.companyName,
                            errorMessage: () => controller.getErrorMessage("Name Company"),
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
