import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../../../../values/config.dart';
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
                        // Company Image - FIXED VERSION
                        Obx(() => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: _buildCompanyImage(),
                          ),
                        )),

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
                              // Updated to use WIB conversion
                              Obx(() => InfoTile(
                                icon: Icons.calendar_today,
                                title: "Dibuat Pada",
                                value: controller.convertToWIB(controller.createdAt.value),
                              )),
                              // Updated to use WIB conversion
                              Obx(() => InfoTile(
                                icon: Icons.update,
                                title: "Diperbarui Pada",
                                value: controller.convertToWIB(controller.updatedAt.value),
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

  Widget _buildCompanyImage() {
    // Menggunakan Config.getImageUrl untuk mendapatkan URL lengkap
    final fullImageUrl = Config.getImageUrl(controller.imagePath.value);

    // Debug: Print URL untuk debugging
    print('🖼️ Detail Company Image URL: $fullImageUrl');
    print('🔍 Original imagePath: ${controller.imagePath.value}');

    // Jika URL menunjuk ke assets (default image), tampilkan fallback
    if (fullImageUrl.startsWith('assets/')) {
      return _fallbackImage();
    }

    return Image.network(
      fullImageUrl,
      width: double.infinity,
      height: 180.h,
      fit: BoxFit.cover,
      headers: Config.commonHeaders, // Menggunakan headers dari config
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: double.infinity,
          height: 180.h,
          color: Colors.grey.shade300,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2.0,
              color: Colors.blue,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Debug: Print error untuk debugging
        print('❌ Detail Company Image load error: $error');
        print('🔗 Failed URL: $fullImageUrl');
        return _fallbackImage();
      },
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 180.h,
      color: Colors.grey[300],
      child: Icon(
        Icons.business,
        size: 50.sp,
        color: Colors.grey[600],
      ),
    );
  }

// Removed old _formatDate function as it's now handled by the controller
}