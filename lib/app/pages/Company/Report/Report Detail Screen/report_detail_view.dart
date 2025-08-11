import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../values/app_color.dart';
import '../../../../global component/CustomAppBar.dart';
import '../../../../global component/CustomTextField.dart';
import '../../Edit Data History Screen/widgets/CustomButtonEdit.dart';
import '../../Edit Data History Screen/widgets/CustomTextFieldEdit.dart';
import 'Widgets/ImagePreview.dart';
import 'report_detail_controller.dart';

class ReportDetailView extends StatelessWidget {
  final ReportDetailController controller = Get.put(ReportDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          if (controller.error.value.isNotEmpty) {
            return _buildErrorState();
          }

          if (controller.report.value == null) {
            return _buildEmptyState();
          }

          return _buildMainContent(context);
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        CustomAppBar(title: "Report Detail", onBackTap: () => Get.back()),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.btnijo),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Memuat detail laporan...",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        CustomAppBar(title: "Report Detail", onBackTap: () => Get.back()),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomButtonEdit(
                  text: "Coba Lagi",
                  backgroundColor: AppColor.btnijo,
                  onPressed: () {
                    final arguments = Get.arguments;
                    if (arguments != null && arguments['reportId'] != null) {
                      controller.fetchReportDetail(arguments['reportId']);
                    }
                  },
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        CustomAppBar(title: "Report Detail", onBackTap: () => Get.back()),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 64.w,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  "Data laporan tidak ditemukan",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Report Detail",
              onBackTap: () => Get.back(),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.backgroundsetengah,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportInfo(),
                  SizedBox(height: 20.h),
                  _buildAreaField(),
                  SizedBox(height: 15.h),
                  _buildInformationField(),
                  SizedBox(height: 15.h),
                  _buildDocumentationSection(context),
                  if (controller.isEditing.value) ...[
                    SizedBox(height: 20.h),
                    _buildSaveButton(),
                  ],
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportInfo() {
    final report = controller.report.value!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Laporan",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.btnijo,
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow("Pengirim", report.namaPengirim),
            _buildInfoRow("Perusahaan", report.company.name),
            _buildInfoRow("Tanggal", report.formattedDate),
            _buildInfoRow("Waktu", report.formattedTime),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaField() {
    return Obx(() {
      if (controller.isEditing.value) {
        return CustomTextFieldEdit(
          label: "Area",
          initialValue: controller.editableArea.value,
          onChanged: (value) => controller.updateEditableArea(value),
        );
      } else {
        return _buildReadOnlyField("Area", controller.report.value!.area);
      }
    });
  }

  Widget _buildInformationField() {
    return Obx(() {
      if (controller.isEditing.value) {
        return CustomTextFieldEdit(
          label: "Information",
          initialValue: controller.editableInformation.value,
          onChanged: (value) => controller.updateEditableInformation(value),
        );
      } else {
        return _buildReadOnlyField(
          "Information",
          controller.report.value!.informasi,
          maxLines: null,
        );
      }
    });
  }

  Widget _buildReadOnlyField(String label, String value, {int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentationSection(BuildContext context) {
    final report = controller.report.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dokumentasi",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        _buildImageContainer(context, report),
      ],
    );
  }

  Widget _buildImageContainer(BuildContext context, report) {
    final imageUrl = controller.getImageUrl(report.dokumentasi);

    return GestureDetector(
      onTap: () {
        if (imageUrl.isNotEmpty) {
          _showImagePreview(context, imageUrl);
        }
      },
      child: Container(
        width: double.infinity,
        height: 204.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.btnijo),
              ),
            ),
            errorWidget: (context, url, error) => _buildErrorImage(),
          )
              : _buildNoImage(),
        ),
      ),
    );
  }

  Widget _buildNoImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48.w,
            color: Colors.grey[500],
          ),
          SizedBox(height: 8.h),
          Text(
            "Tidak ada dokumentasi",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 48.w,
            color: Colors.grey[500],
          ),
          SizedBox(height: 8.h),
          Text(
            "Gagal memuat gambar",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return CustomButtonEdit(
      text: "Simpan Perubahan",
      backgroundColor: AppColor.btnijo,
      onPressed: () => controller.saveChanges(),
      fontSize: 16,
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.025),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.btnijo),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Gagal memuat gambar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}