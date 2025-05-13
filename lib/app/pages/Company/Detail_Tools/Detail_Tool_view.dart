import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../global component/CustomAppBar.dart';
import '../../Client/Account Client/Widgets/InfoTile.dart';
import '../Detail History Screen/widgets/ButtonEdit&Delete.dart';
import 'Detail_Tool_controller.dart';

class DetailToolView extends StatelessWidget {
  DetailToolView({super.key});

  final controller = Get.put(DetailToolController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
                    // Gambar alat dengan border
                    Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            controller.imagePath.value,
                            width: double.infinity,
                            height: 180.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 37.h),

                    // Detail Info Alat
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Column(
                        children: [
                          Obx(() => InfoTile(
                            icon: Icons.build,
                            title: "Nama Alat",
                            value: controller.namaAlat.value,
                          )),
                          Obx(() => InfoTile(
                            icon: Icons.location_on,
                            title: "Lokasi",
                            value: controller.lokasi.value,
                          )),
                          Obx(() => InfoTile(
                            icon: Icons.map,
                            title: "Detail Lokasi",
                            value: controller.detailLokasi.value,
                          )),
                          Obx(() => InfoTile(
                            icon: Icons.info_outline,
                            title: "Kondisi",
                            value: controller.kondisi.value,
                          )),
                          Obx(() => InfoTile(
                            icon: Icons.bug_report,
                            title: "Pest Type",
                            value: controller.pestType.value,
                          )),
                          Obx(() => InfoTile(
                            icon: Icons.qr_code,
                            title: "Kode QR",
                            value: controller.kodeQr.value,
                          )),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Tombol Edit & Delete
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "More",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButtonDetail(
                                icon: Icons.edit,
                                color: AppColor.btnijo,
                                text: 'Edit',
                                onPressed: controller.goToEditTool,
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
                                      onCancelTap: () =>
                                          Navigator.of(context).pop(),
                                      onDeleteTap: () {
                                        Navigator.of(context).pop();
                                        controller.deleteTool();
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
