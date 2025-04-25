  import 'package:admin/values/app_color.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:get/get.dart';
  import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageProfile.dart';
import 'create_account_client_controller.dart';
  
  class CreateAccountClientView extends StatelessWidget {
    CreateAccountClientView({super.key});
  
    final controller = Get.put(CreateAccountClientController());
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColor.background,
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
                          color: AppColor.backgroundsetengah,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
  
                            Obx(() => CustomTextField(
                              label: "Username",
                              controller: controller.usernameController,
                              errorMessage: controller.usernameError.value,
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
