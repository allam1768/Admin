import 'package:get/get.dart';
import '../../../../../data/models/report_model.dart';
import '../../../../../data/services/report_service.dart';
import 'package:flutter/material.dart';

class ReportDetailController extends GetxController {
  final ReportService _reportService = ReportService();

  Rx<ReportModel?> report = Rx<ReportModel?>(null);
  RxBool isLoading = true.obs;
  RxString error = "".obs;

  // For editing mode (if needed)
  RxBool isEditing = false.obs;
  RxString editableArea = "".obs;
  RxString editableInformation = "".obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;

    print('🔍 ReportDetailController - Received arguments: $arguments');

    int? reportId;

    // Check for different possible argument keys
    if (arguments != null) {
      if (arguments['reportId'] != null) {
        reportId = arguments['reportId'];
        print('✅ Found reportId: $reportId');
      } else if (arguments['id'] != null) {
        reportId = arguments['id'];
        print('✅ Found id (converted to reportId): $reportId');
      }
    }

    if (reportId != null) {
      fetchReportDetail(reportId);
    } else {
      print('❌ No valid report ID found in arguments');
      error.value = "Report ID tidak ditemukan";
      isLoading.value = false;
    }
  }

  Future<void> fetchReportDetail(int reportId) async {
    try {
      print('📡 Fetching report detail for ID: $reportId');

      isLoading.value = true;
      error.value = "";

      final reportData = await _reportService.getReportById(reportId);
      report.value = reportData;

      print('✅ Report detail fetched successfully');
      print('📋 Report: ${reportData.area} - ${reportData.informasi}');

      // Initialize editable fields
      editableArea.value = reportData.area;
      editableInformation.value = reportData.informasi;

    } catch (e) {
      print('❌ Failed to fetch report detail: $e');
      error.value = "Gagal memuat detail laporan: ${e.toString()}";
      _showErrorSnackbar("Gagal memuat detail laporan: ${e.toString()}");
    } finally {
      isLoading.value = false;
      print('🏁 fetchReportDetail finished');
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Reset to original values if canceling edit
      if (report.value != null) {
        editableArea.value = report.value!.area;
        editableInformation.value = report.value!.informasi;
      }
    }
  }

  void updateEditableArea(String value) {
    editableArea.value = value;
  }

  void updateEditableInformation(String value) {
    editableInformation.value = value;
  }

  // Method to save edited data (you can implement this based on your API)
  Future<void> saveChanges() async {
    try {
      // Implement update API call here if needed
      // await _reportService.updateReport(report.value!.id, editableArea.value, editableInformation.value);

      _showSuccessSnackbar("Perubahan berhasil disimpan");
      isEditing.value = false;

      // Refresh data
      if (report.value != null) {
        await fetchReportDetail(report.value!.id);
      }
    } catch (e) {
      _showErrorSnackbar("Gagal menyimpan perubahan: ${e.toString()}");
    }
  }

  void _showSuccessSnackbar(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.error, color: Colors.white),
    );
  }

  String getImageUrl(String? dokumentasi) {
    if (dokumentasi == null || dokumentasi.isEmpty) {
      return '';
    }

    // If it's already a full URL, return as is
    if (dokumentasi.startsWith('http')) {
      return dokumentasi;
    }

    // If it's a relative path, prepend the base URL
    return 'https://hamatech.rplrus.com/storage/$dokumentasi';
  }
}