import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
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
            CustomAppBar(
              title: "Create Client",
              onBackTap: controller.goToDashboard,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    ImageProfile(profileImage: controller.profileImage),

                    SizedBox(height: 40.h),

                    // Form Section
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name Field
                          Obx(() => CustomTextField(
                            label: "Name",
                            controller: controller.nameController,
                            errorMessage: controller.nameError.value,
                          )),
                          SizedBox(height: 20.h),

                          // Email Field
                          Obx(() => CustomTextField(
                            label: "Email",
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            errorMessage: controller.emailError.value,
                          )),
                          SizedBox(height: 20.h),

                          // Phone Field
                          Obx(() => CustomTextField(
                            label: "Phone Number",
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            errorMessage: controller.phoneError.value,
                          )),
                          SizedBox(height: 20.h),

                          // Password Field
                          Obx(() => CustomTextField(
                            label: "Password",
                            controller: controller.passwordController,
                            isPassword: true,
                            errorMessage: controller.passwordError.value,
                          )),
                          SizedBox(height: 20.h),

                          // Confirm Password Field
                          Obx(() => CustomTextField(
                            label: "Confirm Password",
                            controller: controller.confirmPasswordController,
                            isPassword: true,
                            errorMessage: controller.confirmPasswordError.value,
                          )),
                          SizedBox(height: 40.h),

                          Obx(
                                () => CustomButton(
                              text: controller.isLoading.value ? "Loading..." : "Save",
                              backgroundColor: AppColor.btnoren,
                              onPressed: controller.isLoading.value ? () {} : controller.validateForm,
                              fontSize: 16.sp,
                            ),
                          ),

                          // Error Message Display
                          Obx(() => controller.errorMessage.value != null
                              ? Container(
                            margin: EdgeInsets.only(top: 15.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage.value!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : SizedBox()),

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
