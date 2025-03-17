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

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  void validateForm() {
    if (selectedCondition.value.isEmpty || amount.value.isEmpty || information.value.isEmpty) {
      showError.value = true;
    } else {
      showError.value = false;
      Get.snackbar("Success", "Data berhasil disimpan",
          backgroundColor: Colors.green, colorText: Colors.white);
      // TODO: Simpan data ke database atau API
    }
  }
}
