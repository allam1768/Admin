import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class EditDataHistoryController extends GetxController {
  RxString selectedCondition = "".obs;
  RxString amount = "".obs;
  RxString information = "".obs;
  RxBool showError = false.obs;

  Rx<File?> imageFile = Rx<File?>(null);
  RxBool imageError = false.obs; // Tambahkan error state untuk border merah

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false; // Reset error jika berhasil ambil gambar
    }
  }

  void validateForm() {
    if (selectedCondition.value.isEmpty ||
        amount.value.isEmpty ||
        information.value.isEmpty ||
        imageFile.value == null) { // Validasi gambar juga
      showError.value = true;
      imageError.value = imageFile.value == null; // Tandai error jika belum ada gambar
    } else {
      showError.value = false;
      imageError.value = false;

      Get.snackbar("Success", "Data berhasil disimpan",
          backgroundColor: Colors.green, colorText: Colors.white);
      // TODO: Simpan data ke database atau API
    }
  }
}
