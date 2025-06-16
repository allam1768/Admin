import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../../data/services/alat_service.dart';
import '../Qr Tool Screen/qr_tool_view.dart';

class CreateQrToolController extends GetxController {
  // Form fields
  RxString name = "".obs;
  RxString area = "".obs;
  RxString detail = "".obs;
  RxBool isLoading = false.obs;
  var selectedType = Rxn<String>();

  // Company ID - will be passed from DetailDataView
  var companyId = 0.obs;

  // Error states
  RxnString nameError = RxnString(null);
  RxnString areaError = RxnString(null);
  RxnString detailError = RxnString(null);
  RxnString typeError = RxnString(null);
  RxBool imageError = false.obs;
  RxBool showError = false.obs;

  // Image
  Rx<File?> imageFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    // Get company ID from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments['companyId'] != null) {
      companyId.value = arguments['companyId'];
    }
  }

  // Cek ekstensi file
  bool isValidImageFormat(String filePath) {
    final validExtensions = ['jpg', 'jpeg', 'png'];
    final extension = filePath.split('.').last.toLowerCase();
    return validExtensions.contains(extension);
  }

  bool isFileSizeValid(File file, {int maxSizeInMB = 2}) {
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return file.lengthSync() <= maxSizeInBytes;
  }

  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (!isValidImageFormat(file.path)) {
        imageFile.value = null;
        imageError.value = true;
        Get.snackbar("Format Tidak Didukung", "Gambar harus jpg, jpeg, atau png.");
      } else if (!isFileSizeValid(file)) {
        imageFile.value = null;
        imageError.value = true;
        Get.snackbar("Ukuran Terlalu Besar", "Gambar tidak boleh lebih dari 2MB.");
      } else {
        imageFile.value = file;
        imageError.value = false;
      }
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (!isValidImageFormat(file.path)) {
        imageFile.value = null;
        imageError.value = true;
        Get.snackbar("Format Tidak Didukung", "Gambar harus jpg, jpeg, atau png.");
      } else if (!isFileSizeValid(file)) {
        imageFile.value = null;
        imageError.value = true;
        Get.snackbar("Ukuran Terlalu Besar", "Gambar tidak boleh lebih dari 2MB.");
      } else {
        imageFile.value = file;
        imageError.value = false;
      }
    }
  }

  // Validasi form
  void validateForm() {
    nameError.value = name.value.isEmpty ? "Name harus diisi!" : null;
    areaError.value = area.value.isEmpty ? "Lokasi harus diisi!" : null;
    detailError.value = detail.value.isEmpty ? "Detail lokasi harus diisi!" : null;
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
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    final randomCode = List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return "$prefix$randomCode";
  }

  // Kirim ke API
  Future<void> _sendToApi() async {
    final image = imageFile.value;
    if (image == null) return;

    isLoading.value = true;

    final qrCode = generateUniqueQrCode();

    final alat = AlatModel(
      namaAlat: name.value,
      lokasi: area.value,
      detailLokasi: detail.value,
      pestType: selectedType.value!,
      kondisi: 'good',
      kodeQr: qrCode,
      id: 0,
      companyId: companyId.value > 0 ? companyId.value : null, // Include company ID
    );

    final response = await AlatService.createAlat(alat, image);

    isLoading.value = false;

    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
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