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
            CustomAppBar(
              title: "Edit Client",
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    GestureDetector(
                      child: Stack(
                        children: [
                          Obx(() => ImageProfile(
                            profileImage: controller.profileImage,
                            // Jika tidak ada profileImage baru, gunakan URL dari worker data
                            imageUrl: controller.profileImage.value == null
                                ? controller.currentClient?.fullImageUrl
                                : null,
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      width: double.infinity,
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
                            label: "Phone Number",
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            errorMessage: controller.phoneError.value,
                            hintText: "e.g., 081234567890 or +6281234567890",
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
                            label: "New Password",
                            controller: controller.passwordController,
                            isPassword: true,
                            errorMessage: controller.passwordError.value,
                            hintText: "Minimal 6 karakter",
                          )),
                          SizedBox(height: 15.h),

                          Obx(() => CustomTextField(
                            label: "Confirm New Password",
                            controller: controller.confirmPasswordController,
                            isPassword: true,
                            errorMessage: controller.confirmPasswordError.value,
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
                            fontSize: 16.sp,
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