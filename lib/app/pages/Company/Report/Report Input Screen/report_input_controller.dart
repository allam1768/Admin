import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../../../data/models/report_model.dart';
import '../../../../../data/services/report_service.dart';

class ReportInputController extends GetxController {
  RxString amount = "".obs;
  RxString information = "".obs;
  RxString areaError = "".obs;
  RxString informationError = "".obs;
  Rx<File?> imageFile = Rx<File?>(null);
  RxBool imageError = false.obs;
  RxBool isLoading = false.obs;

  final ReportService _reportService = ReportService();

  Future<void> takePicture() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  void validateForm() {
    areaError.value = "";
    informationError.value = "";
    imageError.value = false;

    if (amount.value.isEmpty) areaError.value = "Area harus diisi!";
    if (information.value.isEmpty) informationError.value = "Information harus diisi!";
    // Removed image validation - image is now optional
    // if (imageFile.value == null) imageError.value = true;

    bool isValid = amount.value.isNotEmpty &&
        information.value.isNotEmpty;
    // Removed imageFile.value != null from validation

    if (isValid) {
      submitReport();
    }
  }

  Future<void> submitReport() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      await _reportService.createReportWithImage(
        area: amount.value,
        informasi: information.value,
        imageFile: imageFile.value, // This can be null now
      );

      _showSuccessSnackbar("Report berhasil dibuat");
      Get.offNamed("/HistoryReport");
    } catch (e) {
      _showErrorSnackbar("Gagal mengirim laporan: ${e.toString()}");
    } finally {
      isLoading.value = false;
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
}