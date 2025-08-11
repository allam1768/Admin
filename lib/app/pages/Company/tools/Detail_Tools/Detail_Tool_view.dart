import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../values/app_color.dart';
import '../../../../../values/config.dart';
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
                    child: Obx(() => Skeletonizer(
                      enabled: controller.isLoading.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tool Image with Skeleton
                          _buildToolImageSection(),

                          SizedBox(height: 37.h),

                          // Tool Details with Skeleton
                          _buildToolDetailsSection(),

                          SizedBox(height: 20.h),

                          // More Section with Skeleton
                          _buildMoreSection(context),

                          SizedBox(height: 40.h),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolImageSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Obx(() => controller.isLoading.value
            ? _buildSkeletonImage()
            : _buildToolImage()),
      ),
    );
  }

  Widget _buildSkeletonImage() {
    return Container(
      width: double.infinity,
      height: 180.h,
      color: Colors.grey[300],
      child: Bone.square(
        size: 180.h,
      ),
    );
  }

  Widget _buildToolImage() {
    final fullImageUrl = Config.getImageUrl(controller.imagePath.value);

    print('🔧 Detail Tool Image URL: $fullImageUrl');
    print('🔍 Original imagePath: ${controller.imagePath.value}');

    if (fullImageUrl.startsWith('assets/')) {
      return _fallbackImage();
    }

    return Image.network(
      fullImageUrl,
      width: double.infinity,
      height: 180.h,
      fit: BoxFit.cover,
      headers: Config.commonHeaders,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: double.infinity,
          height: 180.h,
          color: Colors.grey.shade300,
          child: Skeletonizer(
            enabled: true,
            child: Bone.square(
              size: 180.h,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('❌ Detail Tool Image load error: $error');
        print('🔗 Failed URL: $fullImageUrl');
        return _fallbackImage();
      },
    );
  }

  Widget _buildToolDetailsSection() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        children: [
          Obx(() => controller.isLoading.value
              ? _buildSkeletonInfoTile(Icons.build, "Nama Alat")
              : InfoTile(
            icon: Icons.build,
            title: "Nama Alat",
            value: controller.namaAlat.value,
          )),
          Obx(() => controller.isLoading.value
              ? _buildSkeletonInfoTile(Icons.location_on, "Lokasi")
              : InfoTile(
            icon: Icons.location_on,
            title: "Lokasi",
            value: controller.lokasi.value,
          )),
          Obx(() => controller.isLoading.value
              ? _buildSkeletonInfoTile(Icons.map, "Detail Lokasi")
              : InfoTile(
            icon: Icons.map,
            title: "Detail Lokasi",
            value: controller.detailLokasi.value,
          )),
          Obx(() => controller.isLoading.value
              ? _buildSkeletonInfoTile(Icons.info_outline, "Kondisi")
              : InfoTile(
            icon: Icons.info_outline,
            title: "Kondisi",
            value: controller.kondisi.value,
          )),
          Obx(() => controller.isLoading.value
              ? _buildSkeletonInfoTile(Icons.bug_report, "Pest Type")
              : InfoTile(
            icon: Icons.bug_report,
            title: "Pest Type",
            value: controller.pestType.value,
          )),
          Obx(() => controller.isLoading.value
              ? _buildSkeletonInfoTile(Icons.qr_code, "Kode QR", hasChevron: true)
              : InfoTile(
            icon: Icons.qr_code,
            title: "Kode QR",
            value: controller.kodeQr.value,
            showChevron: true,
            onTap: () {
              Get.to(() => QrDetailToolView(
                qrData: controller.kodeQr.value,
              ))?.then((_) {
                controller.refreshToolDetail();
              });
            },
          )),
        ],
      ),
    );
  }

  Widget _buildSkeletonInfoTile(IconData icon, String title, {bool hasChevron = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: Colors.grey[400],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Bone.text(
                  words: 2,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (hasChevron)
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20.sp,
            ),
        ],
      ),
    );
  }

  Widget _buildMoreSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => controller.isLoading.value
            ? Bone.text(
          words: 1,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        )
            : Text(
          "More",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        )),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? _buildSkeletonButton()
                  : CustomButtonDetail(
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
                      detailLokasi: controller.detailLokasi.value,
                      pestType: controller.pestType.value,
                      kondisi: controller.kondisi.value,
                      kodeQr: controller.kodeQr.value,
                      imagePath: controller.imagePath.value,
                    ),
                  );
                },
              )),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? _buildSkeletonButton()
                  : CustomButtonDetail(
                text: "Delete",
                icon: Icons.delete,
                color: Colors.red.shade700,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDeleteDialog(
                      onCancelTap: () => Navigator.of(context).pop(),
                      onDeleteTap: () {
                        Navigator.of(context).pop();
                        controller.deleteTool(controller.id.value);
                      },
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonButton() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Bone.button(
        width: 45.h,
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 180.h,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 50.sp,
            color: Colors.grey[600],
          ),
          SizedBox(height: 8.h),
          Text(
            'Image not available',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}