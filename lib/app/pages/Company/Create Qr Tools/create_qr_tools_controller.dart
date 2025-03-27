import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Qr Screen/qr_view.dart';

class CreateQrController extends GetxController {
  RxString name = "".obs;
  RxString area = "".obs;
  var selectedType = Rxn<String>(); // Nullable
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
    if (name.value.isEmpty ||
        area.value.isEmpty ||
        selectedType.value == null ||
        imageFile.value == null) { // Cek apakah gambar sudah diunggah
      showError.value = true;
      imageError.value = imageFile.value == null; // Tandai error jika belum ada gambar
    } else {
      showError.value = false;
      imageError.value = false;

      String qrContent =
          "Hamatech- name: ${name.value}, area: ${area.value}, type: ${selectedType.value}";

      Get.off(() => QrView(qrData: qrContent))?.then((_) {
        // Reset nilai setelah berpindah ke QrView
        name.value = "";
        area.value = "";
        selectedType.value = null;
        imageFile.value = null;
      });
    }
  }
}
