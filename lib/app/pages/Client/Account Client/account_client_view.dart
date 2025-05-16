import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../global component/CustomAppBar.dart';
import '../../Company/Detail History Screen/widgets/ButtonEdit&Delete.dart';
import 'Widgets/InfoCard.dart';
import 'Widgets/InfoTile.dart';
import 'account_client_controller.dart';

class AccountClientView extends StatelessWidget {
  AccountClientView({super.key});

  final controller = Get.find<AccountClientController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Detail", onBackTap: () => Get.back(),),
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "More",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButtonDetail(
                                icon: Icons.edit,
                                color: AppColor.btnijo,
                                text: 'Edit',
                                onPressed: controller.goToEditAccount,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomButtonDetail(
                                text: "Delete",
                                icon: Icons.delete,
                                color: Colors.red.shade700,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ConfirmDeleteDialog(
                                      onCancelTap: () {
                                        Navigator.of(context).pop(); // Tutup dialog
                                      },
                                      onDeleteTap: () {
                                        Navigator.of(context).pop(); // Tutup dialog dulu
                                        controller.deleteAccount();   // Panggil delete
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ],
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
