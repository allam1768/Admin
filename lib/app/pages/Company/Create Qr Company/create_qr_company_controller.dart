import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Qr Company Screen/qr_company_view.dart';

class CreateQrCompanyController extends GetxController {
  RxString name = "".obs;
  RxString address = "".obs;
  RxString phoneNumber = "".obs;
  RxString email = "".obs;

  RxString nameError = "".obs;
  RxString addressError = "".obs;
  RxString phoneError = "".obs;
  RxString emailError = "".obs;
  RxBool imageError = false.obs;

  Rx<File?> imageFile = Rx<File?>(null);

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  void validateForm() {
    bool isValid = true;

    nameError.value = name.value.isEmpty ? "Name Company harus diisi!" : "";
    addressError.value = address.value.isEmpty ? "Address Company harus diisi!" : "";
    phoneError.value = phoneNumber.value.isEmpty ? "Phone number harus diisi!" : "";
    emailError.value = email.value.isEmpty ? "Email Company harus diisi!" : "";

    if (nameError.value.isNotEmpty ||
        addressError.value.isNotEmpty ||
        phoneError.value.isNotEmpty ||
        emailError.value.isNotEmpty ) {
      isValid = false;
    }

    if (isValid) {
      String qrContent =
          "Hmt-Company: ${name.value}, address: ${address.value}, phone: ${phoneNumber.value}, email: ${email.value}, }";

      Get.off(() => QrCompanyView(qrData: qrContent));
    }
  }
}
