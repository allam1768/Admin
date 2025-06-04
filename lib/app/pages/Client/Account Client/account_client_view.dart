import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/ButtonEdit&Delete.dart';
import 'Widgets/InfoCard.dart';
import 'Widgets/InfoTile.dart';
import 'account_client_controller.dart';

class AccountClientView extends StatelessWidget {
  AccountClientView({super.key});

  final controller = Get.put(AccountClientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Detail Client",
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  // Show loading indicator
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: 400.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.btnijo,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),

                        // User Card
                        UserInfoCard(
                          name: controller.userName.value,
                          email: controller.userEmail.value,
                          imagePath: controller.profileImage.value,
                        ),

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
                              InfoTile(
                                  icon: Icons.badge,
                                  title: "Client ID",
                                  value: controller.clientId.value.isNotEmpty
                                      ? controller.clientId.value
                                      : "-"
                              ),
                              InfoTile(
                                  icon: Icons.person,
                                  title: "Name",
                                  value: controller.fullName.value.isNotEmpty
                                      ? controller.fullName.value
                                      : controller.userName.value
                              ),
                              InfoTile(
                                  icon: Icons.phone,
                                  title: "Phone number",
                                  value: controller.phoneNumber.value
                              ),
                              InfoTile(
                                  icon: Icons.email,
                                  title: "Email",
                                  value: controller.userEmail.value
                              ),
                              InfoTile(
                                icon: Icons.person_outline,
                                title: "Role",
                                value: "Client",
                              ),
                              InfoTile(
                                icon: Icons.calendar_today,
                                title: "Created At",
                                value: controller.createdAt.value,
                              ),
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
                                            Navigator.of(context).pop();
                                          },
                                          onDeleteTap: () {
                                            Navigator.of(context).pop();
                                            controller.deleteAccount();
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

                        SizedBox(height: 20.h),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}