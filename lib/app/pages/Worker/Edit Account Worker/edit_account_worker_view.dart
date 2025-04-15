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
            CustomAppBar(title: "Edit Worker"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    ImageProfile(profileImage: controller.profileImage),
                    SizedBox(height: 25.h),
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

                          CustomTextField(
                            label: "Name",
                            onChanged: controller.name,
                            errorMessage: controller.getErrorMessage("Name"),
                          ),
                          SizedBox(height: 12.h),

                          CustomTextField(
                            label: "Phone number",
                            onChanged: controller.phoneNumber,
                            isNumber: true,
                            errorMessage:  controller.getErrorMessage("Phone number"),
                          ),
                          SizedBox(height: 12.h),

                          CustomTextField(
                            label: "Email",
                            onChanged: controller.email,
                            errorMessage:  controller.getErrorMessage("Email"),
                          ),
                          SizedBox(height: 12.h),

                          CustomTextField(
                            label: "Password",
                            onChanged: controller.password,
                            isPassword: true,
                            errorMessage: controller.getErrorMessage("Password"),
                          ),
                          SizedBox(height: 12.h),

                          CustomTextField(
                            label: "Confirm Password",
                            onChanged: controller.confirmPassword,
                            isPassword: true,
                            errorMessage:  controller.getErrorMessage("Confirm Password"),
                          ),


                          SizedBox(height: 30.h),
                          CustomButton(
                            text: "Save",
                            backgroundColor: AppColor.btnijo,
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
