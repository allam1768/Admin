import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageProfile.dart';
import 'create_account_worker_controller.dart';

class CreateAccountWorkerView extends StatelessWidget {
  CreateAccountWorkerView({super.key});

  final controller = Get.put(CreateAccountWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Create Worker",
              onBackTap: controller.goToDashboard,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    ImageProfile(profileImage: controller.profileImage),
                    SizedBox(height: 70.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.w, vertical: 16.h),
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
                                label: "Email",
                                controller: controller.emailController,
                                keyboardType: TextInputType.emailAddress,
                                errorMessage: controller.emailError.value,
                              )),
                          SizedBox(height: 15.h),

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
                                controller:
                                    controller.confirmPasswordController,
                                isPassword: true,
                                errorMessage:
                                    controller.confirmPasswordError.value,
                              )),
                          SizedBox(height: 60.h),

                          Obx(
                            () => controller.isLoading.value
                                ? Center(child: CircularProgressIndicator())
                                : CustomButton(
                                    text: "Save",
                                    backgroundColor: AppColor.btnoren,
                                    onPressed: controller.validateForm,
                                    fontSize: 16,
                                  ),
                          ),

                          // Menampilkan pesan error jika ada
                          Obx(
                            () => controller.errorMessage.value != null
                                ? Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      controller.errorMessage.value!,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14.sp),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : SizedBox(),
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
