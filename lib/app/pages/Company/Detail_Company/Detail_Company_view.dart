import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../../../dialogs/ConfirmDeleteDialog.dart';
import '../../../global component/ButtonEdit&Delete.dart';
import '../../../global component/CustomAppBar.dart';
import '../Qr Detail company Screen/qr_detail_company_view.dart';
import 'Detail_Company_controller.dart';
import 'Widgets/InfoTile.dart';

class DetailCompanyView extends StatelessWidget {
  DetailCompanyView({super.key});

  final controller = Get.put(DetailCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Detail Company",
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshCompanyDetail,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Image
                        Obx(
                              () => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: controller.imagePath.value.isNotEmpty
                                  ? Image.network(
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
                                      value: loadingProgress
                                          .expectedTotalBytes !=
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
                                    child: Icon(Icons.business,
                                        size: 50, color: Colors.grey[600]),
                                  );
                                },
                              )
                                  : Container(
                                width: double.infinity,
                                height: 180.h,
                                color: Colors.grey[300],
                                child: Icon(Icons.business,
                                    size: 50, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 37.h),

                        // Company Details
                        Container(
                          padding: EdgeInsets.all(18.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Column(
                            children: [
                              Obx(() => InfoTile(
                                icon: Icons.business,
                                title: "Nama Company",
                                value: controller.companyName.value,
                              )),
                              // Added QR Code display

                              Obx(() => InfoTile(
                                icon: Icons.location_on,
                                title: "Alamat",
                                value: controller.companyAddress.value,
                              )),
                              Obx(() => InfoTile(
                                icon: Icons.phone,
                                title: "Nomor Telepon",
                                value: controller.phoneNumber.value,
                              )),
                              Obx(() => InfoTile(
                                icon: Icons.email,
                                title: "Email",
                                value: controller.email.value,
                              )),
                              Obx(() => InfoTile(
                                icon: Icons.qr_code,
                                title: "Kode QR",
                                value: controller.companyQr.value,
                                showChevron: true,
                                onTap: () {
                                  Get.to(() => QrDetailCompanyView(
                                    qrData: controller.companyQr.value,
                                  ))?.then((_) {
                                  });
                                },
                              )),
                              Obx(() => InfoTile(
                                icon: Icons.calendar_today,
                                title: "Dibuat Pada",
                                value: _formatDate(controller.createdAt.value),
                              )),
                              Obx(() => InfoTile(
                                icon: Icons.update,
                                title: "Diperbarui Pada",
                                value: _formatDate(controller.updatedAt.value),
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
                                            controller.deleteCompany(
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

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}