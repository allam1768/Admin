import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global component/app_bar.dart';
import '../../../global component/ButtonEdit&Delete_account.dart';
import '../../Worker/Account Worker/Widgets/InfoCard.dart';
import '../../Worker/Account Worker/Widgets/InfoTile.dart';
import 'account_client_controller.dart';

class AccountClientView extends StatelessWidget {
  AccountClientView({super.key});

  final controller = Get.find<AccountClientController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Detail"),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    // User Card
                    Obx(() => UserInfoCard(
                      name: controller.userName.value,
                      email: controller.userEmail.value,
                      imagePath: controller.profileImage.value,
                    )),

                    SizedBox(height: 37.h),

                    // Detail Info
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Column(
                        children: [
                          Obx(() => InfoTile(icon: Icons.person, title: "Name", value: controller.fullName.value)),
                          Obx(() => InfoTile(icon: Icons.business, title: "Company", value: controller.company.value)),
                          Obx(() => InfoTile(icon: Icons.phone, title: "Phone number", value: controller.phoneNumber.value)),
                          Obx(() => InfoTile(icon: Icons.email, title: "Email", value: controller.userEmail.value)),
                          Obx(() => InfoTile(
                            icon: Icons.lock,
                            title: "Password",
                            value: controller.isPasswordVisible.value ? controller.password.value : "********",
                            isPassword: true,
                            onTogglePassword: controller.togglePasswordVisibility,
                          )),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Action Buttons
                    ActionButtons(
                      onEdit: controller.goToEditAccount,
                      onDelete: controller.deleteAccount,
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
