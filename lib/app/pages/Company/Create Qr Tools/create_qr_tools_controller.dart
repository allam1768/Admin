import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Qr Tool Screen/qr_tool_view.dart';

class CreateQrController extends GetxController {
  RxString name = "".obs;
  RxString area = "".obs;
  var selectedType = Rxn<String>(); // Nullable
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
        area.value.isEmpty ||
        selectedType.value == null ||
        imageFile.value == null) {
      showError.value = true;
      imageError.value = imageFile.value == null;
    } else {
      showError.value = false;
      imageError.value = false;

      String qrContent =
          "Hamatech- name: ${name.value}, area: ${area.value}, type: ${selectedType.value}";

      Get.off(() => QrToolView(qrData: qrContent))?.then((_) {
        name.value = "";
        area.value = "";
        selectedType.value = null;
        imageFile.value = null;
      });
    }
  }
}
