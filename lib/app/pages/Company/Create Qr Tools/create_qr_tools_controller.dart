import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../Qr Screen/qr_screen.dart';

class CreateQrController extends GetxController {
  RxString name = "".obs;
  RxString area = "".obs;
  var selectedType = Rxn<String>(); // Nullable
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
    if (name.value.isEmpty || area.value.isEmpty || selectedType.value == null) {
      showError.value = true;
    } else {
      showError.value = false;
      String qrContent = "Name: ${name.value}, Area: ${area.value}, Type: ${selectedType.value}";
      Get.to(() => QrScreen(qrData: qrContent));
    }
  }
}
