import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Qr Tool Screen/qr_tool_view.dart';

class CreateQrToolController extends GetxController {
  RxString name = "".obs;
  RxString area = "".obs;
  var selectedType = Rxn<String>();
  RxBool showError = false.obs;

  Rx<File?> imageFile = Rx<File?>(null);
  RxBool imageError = false.obs;

  RxnString nameError = RxnString(null);
  RxnString areaError = RxnString(null);
  RxnString typeError = RxnString(null);

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  void validateForm() {
    nameError.value = name.value.isEmpty ? "Name harus diisi!" : null;
    areaError.value = area.value.isEmpty ? "Area harus diisi!" : null;
    typeError.value = selectedType.value == null ? "Type harus dipilih!" : null;
    imageError.value = imageFile.value == null;

    showError.value = nameError.value != null ||
        areaError.value != null ||
        typeError.value != null ||
        imageError.value;

    if (!showError.value) {
      String qrContent =
          "Hamatech- name: ${name.value}, area: ${area.value}, type: ${selectedType.value}";

      Get.off(() => QrToolView(qrData: qrContent))?.then((_) {
        name.value = "";
        area.value = "";
        selectedType.value = null;
        imageFile.value = null;
        nameError.value = null;
        areaError.value = null;
        typeError.value = null;
        imageError.value = false;
      });
    }
  }
}
