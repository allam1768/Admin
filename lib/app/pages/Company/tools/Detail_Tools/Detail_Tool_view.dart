import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../values/app_color.dart';
import '../../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../../global component/CustomAppBar.dart';
import '../../../../global component/ButtonEdit&Delete.dart';
import '../Qr Detail Tool Screen/qr_detail_tool_view.dart';
import 'Detail_Tool_controller.dart';
import 'Widgets/InfoTile.dart';

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
            CustomAppBar(
              title: "Detail",
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshToolDetail,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tool Image
                        Obx(
                              () => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                controller.imagePath.value,
                                width: double.infinity,
                                height: 180.h,
                                fit: BoxFit.cover,
                                headers: {
                                  'ngrok-skip-browser-warning': '1',
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                      loadingProgress.expectedTotalBytes !=
                                          null
                                          ? loadingProgress
                                          .cumulativeBytesLoaded /
                                          loadingProgress
                                              .expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 180.h,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error_outline,
                                        size: 50, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 37.h),

                        // Tool Details
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
                                showChevron: true,
                                onTap: () {
                                  // Navigate to QR Code page and handle return
                                  Get.to(() => QrDetailToolView(
                                    qrData: controller.kodeQr.value,
                                  ))?.then((_) {
                                    // Callback when returning from QR page
                                    controller.refreshToolDetail();
                                  });
                                },
                              )),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Edit & Delete Buttons
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
                                    onPressed: () {
                                      Get.toNamed(
                                        Routes.updatetool,
                                        arguments: AlatModel(
                                          id: controller.id.value,
                                          namaAlat: controller.namaAlat.value,
                                          lokasi: controller.lokasi.value,
                                          detailLokasi:
                                          controller.detailLokasi.value,
                                          pestType: controller.pestType.value,
                                          kondisi: controller.kondisi.value,
                                          kodeQr: controller.kodeQr.value,
                                          imagePath: controller.imagePath.value,
                                        ),
                                      );
                                    },
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
                                            controller.deleteTool(
                                                controller.id.value);
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

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}