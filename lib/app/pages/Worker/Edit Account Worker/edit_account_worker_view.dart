import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/ImageProfile.dart';
import 'edit_account_worker_controller.dart';

class EditAccountWorkerView extends StatelessWidget {
  EditAccountWorkerView({super.key});

  final EditAccountWorkerController controller = Get.put(EditAccountWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Edit Worker",
              onBackTap: controller.goBack,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // Profile Image dengan opsi untuk mengganti
                    GestureDetector(
                      child: Stack(
                        children: [
                          Obx(() => ImageProfile(
                            profileImage: controller.profileImage,
                            // Jika tidak ada profileImage baru, gunakan URL dari worker data
                            imageUrl: controller.profileImage.value == null
                                ? controller.currentWorker?.fullImageUrl
                                : null,
                          )),
                        ],
                      ),
                    ),

                    SizedBox(height: 25.h),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name Field
                          Obx(() => CustomTextField(
                            label: "Name",
                            initialValue: controller.name.value,
                            onChanged: (value) => controller.name.value = value,
                            errorMessage: controller.getErrorMessage("Name"),
                          )),
                          SizedBox(height: 12.h),

                          // Phone Number Field
                          Obx(() => CustomTextField(
                            label: "Phone number",
                            initialValue: controller.phoneNumber.value,
                            onChanged: (value) => controller.phoneNumber.value = value,
                            isNumber: true,
                            errorMessage: controller.getErrorMessage("Phone number"),
                          )),
                          SizedBox(height: 12.h),

                          // Email Field
                          Obx(() => CustomTextField(
                            label: "Email",
                            initialValue: controller.email.value,
                            onChanged: (value) => controller.email.value = value,
                            errorMessage: controller.getErrorMessage("Email"),
                          )),
                          SizedBox(height: 12.h),

                          // Password Field (Optional)
                          Obx(() => CustomTextField(
                            label: "Password (Kosongkan jika tidak ingin mengubah)",
                            onChanged: (value) => controller.password.value = value,
                            isPassword: true,
                            errorMessage: controller.getErrorMessage("Password"),
                          )),
                          SizedBox(height: 12.h),

                          // Confirm Password Field (Optional)
                          Obx(() => CustomTextField(
                            label: "Confirm Password",
                            onChanged: (value) => controller.confirmPassword.value = value,
                            isPassword: true,
                            errorMessage: controller.getErrorMessage("Confirm Password"),
                          )),

                          SizedBox(height: 50.h),
                          Obx(() => CustomButton(
                            text: controller.isLoading.value
                                ? "Loading..."
                                : "Save",
                            backgroundColor: controller.canSave
                                ? AppColor.btnoren
                                : Colors.grey,
                            onPressed: controller.canSave
                                ? controller.validateForm
                                : () {},
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