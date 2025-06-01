import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../global component/CustomAppBar.dart';
import '../../Client/Account Client/Widgets/InfoTile.dart';
import '../../../global component/ButtonEdit&Delete.dart';
import 'Widgets/InfoCard.dart';
import 'account_worker_controller.dart';

class AccountWorkerView extends StatelessWidget {
  AccountWorkerView({super.key});

  final controller = Get.put(AccountWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            CustomAppBar(
              title: "Detail Worker",
              onBackTap: controller.goToDashboard,
            ),

            Expanded(
              child: Obx(() {
                // Tampilkan loading jika data belum tersedia
                if (controller.selectedWorker.value == null) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat data worker...'),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),

                      // User Card dengan data real
                      UserInfoCard(
                        name: controller.workerName,
                        email: controller.workerEmail,
                        imagePath: controller.workerImageUrl ?? "assets/images/default_profile.png",
                      ),

                      SizedBox(height: 37.h),

                      // Detail Info dengan data real
                      Container(
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Column(
                          children: [
                            InfoTile(
                              icon: Icons.person,
                              title: "Name",
                              value: controller.workerName,
                            ),
                            InfoTile(
                              icon: Icons.email, // Tambahkan InfoTile untuk email
                              title: "Email",
                              value: controller.workerEmail,
                            ),
                            InfoTile(
                              icon: Icons.phone,
                              title: "Phone number",
                              value: controller.workerPhone,
                            ),
                            InfoTile(
                              icon: Icons.badge,
                              title: "Worker ID",
                              value: controller.workerId,
                            ),
                            InfoTile(
                              icon: Icons.work,
                              title: "Role",
                              value: controller.workerRole.toUpperCase(),
                            ),
                            InfoTile(
                              icon: Icons.calendar_today,
                              title: "Created At",
                              value: _formatDate(controller.selectedWorker.value!.createdAt),
                            ),
                            // Password tidak ditampilkan karena tidak tersedia di model
                            // Obx(() => InfoTile(
                            //   icon: Icons.lock,
                            //   title: "Password",
                            //   value: controller.isPasswordVisible.value ? "password123" : "********",
                            //   isPassword: true,
                            //   onTogglePassword: controller.togglePasswordVisibility,
                            // )),
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
                                child: Obx(() => controller.isLoading.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : CustomButtonDetail(
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
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}