import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/CustomButton.dart';
import '../../../global component/CustomImagePicker.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/app_bar.dart';
import 'create_account_worker_controller.dart';

class CreateAccountWorkerView extends StatelessWidget {
  CreateAccountWorkerView({super.key});

  final CreateAccountWorkerController controller = Get.put(CreateAccountWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Edit Worker"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    ImagePickerComponent(profileImage: controller.profileImage),

                    SizedBox(height: 20.h),

                    Container(
                      color: const Color(0xFFBBD4C3),
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: "Name",
                            onChanged: (value) => controller.name.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.name.value.isEmpty
                              ? errorText("Name harus diisi!")
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Phone number",
                            onChanged: (value) => controller.phoneNumber.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.phoneNumber.value.isEmpty
                              ? errorText("Phone number harus diisi!")
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Email",
                            onChanged: (value) => controller.email.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.email.value.isEmpty
                              ? errorText("Email harus diisi!")
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Password",
                            isPassword: true,
                            onChanged: (value) => controller.password.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.password.value.isEmpty
                              ? errorText("Password harus diisi!")
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Confirm Password",
                            isPassword: true,
                            onChanged: (value) => controller.confirmPassword.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.confirmPassword.value.isEmpty
                              ? errorText("Confirm Password harus diisi!")
                              : controller.password.value != controller.confirmPassword.value
                              ? errorText("Password tidak cocok!")
                              : SizedBox()),
                          SizedBox(height: 20.h),

                          CustomButton(
                            text: "Save",
                            color: Color(0xFF275637),
                            onPressed: () {
                              controller.validateForm();
                            },
                            fontSize: 20,
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

  Widget errorText(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Text(
        message,
        style: TextStyle(fontSize: 14.sp, color: Colors.red),
      ),
    );
  }
}
