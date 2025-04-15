import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageProfile.dart';
import 'edit_account_client_controller.dart';

class EditAccountClientView extends StatelessWidget {
  EditAccountClientView({super.key});

  final EditAccountClientController controller = Get.put(EditAccountClientController());


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColor.background,
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
                  SizedBox(height: 30.h),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 180.h, // Sesuaikan dengan tinggi layar
                    ),
                    color: AppColor.backgroundsetengah,
                    padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => CustomTextField(
                          label: "Name",
                          controller: controller.nameController,
                          errorMessage: controller.nameError.value,
                        )),
                        SizedBox(height: 15.h),

                        Obx(() => CustomTextField(
                          label: "Name Company",
                          controller: controller.nameCompanyController,
                          errorMessage: controller.nameCompanyError.value,
                        )),

                        SizedBox(height: 16.h),

                        Obx(() => CustomTextField(
                          label: "Phone Number",
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          errorMessage: controller.phoneError.value,
                        )),
                        SizedBox(height: 15.h),

                        Obx(() => CustomTextField(
                          label: "Email",
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorMessage: controller.emailError.value,
                        )),
                        SizedBox(height: 15.h),

                        Obx(() => CustomTextField(
                          label: "Password",
                          controller: controller.passwordController,
                          isPassword: true,
                          errorMessage: controller.passwordError.value,
                        )),
                        SizedBox(height: 15.h),

                        Obx(() => CustomTextField(
                          label: "Confirm Password",
                          controller: controller.confirmPasswordController,
                          isPassword: true,
                          errorMessage: controller.confirmPasswordError.value,
                        )),
                        SizedBox(height: 40.h),

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

