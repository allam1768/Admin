import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/CustomAppBar.dart';
import '../../Client/Account Client/Widgets/InfoTile.dart';
import '../../Company/Detail History Screen/widgets/ButtonEdit&Delete.dart';
import 'Widgets/InfoCard.dart';
import 'account_worker_controller.dart';

class AccountWorkerView extends StatelessWidget {
  AccountWorkerView({super.key});

  final controller = Get.find<AccountWorkerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            CustomAppBar(title: "Detail"),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    // User Card
                    UserInfoCard(
                      name: "Wawan",
                      email: "abc@gmail.com",
                      imagePath: "https://example.com/profile.jpg",
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
                          InfoTile(icon: Icons.person, title: "Name", value: "Wawan Ajay Gimang"),
                          InfoTile(icon: Icons.phone, title: "Phone number", value: "087788987208"),
                          InfoTile(icon: Icons.email, title: "Email", value: "dumyemail@gmail.com"),
                          Obx(() => InfoTile(
                            icon: Icons.lock,
                            title: "Password",
                            value: controller.isPasswordVisible.value ? "password123" : "********",
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
                                onPressed: controller.navigateToEditAccount,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomButtonDetail(
                                text: "Delete",
                                icon: Icons.delete,
                                color: Colors.red.shade700,
                                onPressed: controller.deleteAccount,
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
