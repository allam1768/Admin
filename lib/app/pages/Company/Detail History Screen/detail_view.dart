import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/ImagePreviewCard.dart';
import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/info_container.dart';
import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/karyawan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../global component/ButtonEdit&Delete.dart';
import '../../../global component/CustomAppBar.dart';
import 'detail_controller.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.put(DetailController());

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => CustomAppBar(title:controller.title.value, onBackTap: () => Get.back(),)),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColor.ijomuda,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Loading detail data...",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: AppColor.ijomuda,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),

                          // Image Preview
                          Hero(
                            tag: 'preview_image_${controller.catchId.value}',
                            child: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(15.r),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Obx(() => ImagePreviewCard(
                                  imageUrl: controller.imagePath.value,
                                  imageTitle: controller.jenisHama.value,
                                )),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Main Information Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Employee Card
                                Obx(() => EmployeeCard(
                                  name: controller.namaKaryawan.value,
                                  employeeNumber: controller.nomorKaryawan.value,
                                  date: controller.tanggalJam.value,
                                )),
                                Divider(height: 1, color: Colors.grey.withOpacity(0.3)),

                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    children: [
                                      // Catch Information Section
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 16.h),
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          color: AppColor.ijomuda.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(15.r),
                                          border: Border.all(color: AppColor.ijomuda.withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.bug_report,
                                                  size: 20.sp,
                                                  color: AppColor.ijomuda,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "Catch Information",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12.h),
                                            Obx(() => Column(
                                              children: [
                                                _buildCatchInfoRow("Pest Type", controller.jenisHama.value, Icons.bug_report_outlined),
                                                SizedBox(height: 8.h),
                                                _buildCatchInfoRow("Amount", "${controller.jumlah.value} pcs", Icons.numbers),
                                                SizedBox(height: 8.h),
                                                _buildCatchInfoRow("Date", controller.tanggal.value, Icons.calendar_today),
                                                SizedBox(height: 8.h),
                                                _buildCatchInfoRow("Tool Condition", controller.kondisi.value, Icons.build_circle,
                                                    valueColor: _getConditionColor(controller.kondisi.value)),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),

                                      // Notes/Information
                                      Obx(() => InfoContainer(
                                        title: "Notes",
                                        content: controller.informasi.value.isEmpty
                                            ? "No notes available"
                                            : controller.informasi.value,
                                      )),
                                      SizedBox(height: 16.h),

                                      // Action Buttons
                                      // Ganti bagian Row dengan action buttons:
                                      Row(
                                        children: [
                                          Obx(() => controller.canEdit.value
                                              ? Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 8.w),
                                              child: CustomButtonDetail(
                                                icon: Icons.edit,
                                                color: AppColor.btnijo,
                                                text: 'Edit',
                                                onPressed: controller.editData,
                                              ),
                                            ),
                                          )
                                              : const SizedBox()),

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
                                                      controller.deleteData();
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          ": ",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? "N/A" : value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCatchInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: Colors.black54,
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 80.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          ": ",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? "N/A" : value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'baik':
      case 'good':
        return Colors.green;
      case 'rusak':
      case 'broken':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.black87;
    }
  }
}