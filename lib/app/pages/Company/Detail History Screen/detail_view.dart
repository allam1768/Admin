import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/ButtonEdit&Delete.dart';
import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/info_card.dart';
import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/info_container.dart';
import 'package:admin/app/pages/Company/Detail%20History%20Screen/widgets/karyawan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/app_bar.dart';
import 'detail_controller.dart';

class DetailHistoryView extends StatelessWidget {
  const DetailHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Detail"),
            const Spacer(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFBBD4C3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    controller.title.value,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
                  )),
                  SizedBox(height: 12.h),
                  Obx(() => EmployeeCard(
                    name: controller.namaKaryawan.value,
                    employeeNumber: controller.nomorKaryawan.value,
                    date: controller.tanggalJam.value,
                  )),
                  SizedBox(height: 12.h),
                  Obx(() => Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: controller.imagePath.value.isNotEmpty
                        ? Image.asset(controller.imagePath.value, fit: BoxFit.cover)
                        : Center(
                      child: Icon(Icons.image, size: 48.sp, color: Colors.white),
                    ),
                  )),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Obx(() => Expanded(
                        child: InfoCard(title: "Condition", value: controller.kondisi.value),
                      )),
                      SizedBox(width: 12.w),
                      Obx(() => Expanded(
                        child: InfoCard(title: "Amount", value: controller.jumlah.value),
                      )),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => InfoContainer(
                    title: "Information",
                    content: controller.informasi.value,
                  )),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonDetail(
                          icon: Icons.edit,
                          color: const Color(0xFF275637),
                          text: 'Edit',
                          onPressed: controller.editData,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomButtonDetail(
                          text: "Delete",
                          icon: Icons.delete,
                          color: Colors.red.shade700,
                          onPressed: controller.deleteData,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
