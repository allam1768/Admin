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
  RxString industry = "".obs;
  RxBool showError = false.obs;

  Rx<File?> imageFile = Rx<File?>(null);
  RxBool imageError = false.obs;

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  void validateForm() {
    if (name.value.isEmpty ||
        address.value.isEmpty ||
        phoneNumber.value.isEmpty ||
        email.value.isEmpty ||
        industry.value.isEmpty ) {
      showError.value = true;
    } else {
      showError.value = false;
      imageError.value = false;

      String qrContent =
          "Company- name: ${name.value}, address: ${address.value}, phone: ${phoneNumber.value}, email: ${email.value}, industry: ${industry.value}";

      // Pindah ke QrCompanyView dengan data QR
      Get.off(() => QrCompanyView(qrData: qrContent));
    }
  }

  Widget showErrorMessage(String fieldName) {
    if (!showError.value) return SizedBox();

    String message = "";
    if (fieldName == "Name Company" && name.value.isEmpty) {
      message = "Name Company harus diisi!";
    } else if (fieldName == "Address Company" && address.value.isEmpty) {
      message = "Address Company harus diisi!";
    } else if (fieldName == "Phone number" && phoneNumber.value.isEmpty) {
      message = "Phone number harus diisi!";
    } else if (fieldName == "Email Company" && email.value.isEmpty) {
      message = "Email Company harus diisi!";
    } else if (fieldName == "Industry" && industry.value.isEmpty) {
      message = "Industry harus diisi!";
    }

    return message.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        message,
        style: TextStyle(fontSize: 12, color: Colors.red),
      ),
    )
        : SizedBox();
  }
}
