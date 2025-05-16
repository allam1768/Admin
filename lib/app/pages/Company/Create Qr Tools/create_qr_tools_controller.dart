import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/alat_model.dart';
import '../../../../data/services/alat_service.dart';
import '../Qr Tool Screen/qr_tool_view.dart';

class CreateQrToolController extends GetxController {
  // Form fields
  RxString name = "".obs;
  RxString area = "".obs;
  RxString detail = "".obs;
  var selectedType = Rxn<String>();

  // Error states
  RxnString nameError = RxnString(null);
  RxnString areaError = RxnString(null);
  RxnString detailError = RxnString(null);
  RxnString typeError = RxnString(null);
  RxBool imageError = false.obs;
  RxBool showError = false.obs;

  // Image
  Rx<File?> imageFile = Rx<File?>(null);

  // Cek ekstensi file
  bool isValidImageFormat(String filePath) {
    final validExtensions = ['jpg', 'jpeg', 'png'];
    final extension = filePath.split('.').last.toLowerCase();
    return validExtensions.contains(extension);
  }

  // Ambil dari kamera
  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (isValidImageFormat(pickedFile.path)) {
        imageFile.value = File(pickedFile.path);
        imageError.value = false;
      } else {
        imageFile.value = null;
        imageError.value = true;
        Get.snackbar(
            "Format Tidak Didukung", "Gambar harus jpg, jpeg, atau png.");
      }
    }
  }

  // Ambil dari galeri
  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (isValidImageFormat(pickedFile.path)) {
        imageFile.value = File(pickedFile.path);
        imageError.value = false;
      } else {
        imageFile.value = null;
        imageError.value = true;
        Get.snackbar(
            "Format Tidak Didukung", "Gambar harus jpg, jpeg, atau png.");
      }
    }
  }

  // Validasi form
  void validateForm() {
    nameError.value = name.value.isEmpty ? "Name harus diisi!" : null;
    areaError.value = area.value.isEmpty ? "Lokasi harus diisi!" : null;
    detailError.value =
        detail.value.isEmpty ? "Detail lokasi harus diisi!" : null;
    typeError.value = selectedType.value == null ? "Type harus dipilih!" : null;
    imageError.value = imageFile.value == null;

    showError.value = nameError.value != null ||
        areaError.value != null ||
        detailError.value != null ||
        typeError.value != null ||
        imageError.value;

    if (!showError.value) {
      _sendToApi();
    }
  }

  // Generate QR unik
  String generateUniqueQrCode() {
    const prefix = "Hmt-Tool-";
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    final randomCode =
        List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return "$prefix$randomCode";
  }

  // Kirim ke API
  Future<void> _sendToApi() async {
    final image = imageFile.value;
    if (image == null) return;

    final qrCode = generateUniqueQrCode();

    final alat = AlatModel(
      namaAlat: name.value,
      lokasi: area.value,
      detail_lokasi: detail.value,
      pestType: selectedType.value!,
      kondisi: 'good',
      kodeQr: qrCode,
      id: 0,
    );

    final response = await AlatService.createAlat(alat, image);

    print("STATUS: ${response?.statusCode}");
    print("BODY: ${response?.body}");

    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Get.off(() => QrToolView(qrData: qrCode))?.then((_) => _resetForm());
    } else {
      Get.snackbar("Gagal", "Gagal mengirim data ke server.");
    }
  }

  // Reset form
  void _resetForm() {
    name.value = "";
    area.value = "";
    detail.value = "";
    selectedType.value = null;
    imageFile.value = null;

    nameError.value = null;
    areaError.value = null;
    typeError.value = null;
    imageError.value = false;
    showError.value = false;
  }
}
