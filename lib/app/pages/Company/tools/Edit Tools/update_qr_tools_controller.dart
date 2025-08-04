// edit_tool_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../../data/services/alat_service.dart';

class EditToolController extends GetxController {
  // State
  var isLoading = false.obs;


  // Input controllers
  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final detailLokasiController = TextEditingController();

  var selectedType = RxnString();
  var selectedKondisi = RxnString();
  var imageFile = Rxn<File>();
  var imageError = ''.obs;

  // Current alat data
  late AlatModel currentAlat;

  // Error messages
  var namaError = ''.obs;
  var lokasiError = ''.obs;
  var detailLokasiError = ''.obs;

  void init(AlatModel alat) {
    currentAlat = alat;
    namaController.text = alat.namaAlat;
    lokasiController.text = alat.lokasi;
    detailLokasiController.text = alat.detailLokasi;
    selectedType.value = alat.pestType;

    // ✅ Map kondisi dari model ke dropdown value
    selectedKondisi.value = mapKondisiFromModel(alat.kondisi);

    // ✅ Debug print untuk troubleshooting
    print('Original kondisi: ${alat.kondisi}');
    print('Mapped kondisi: ${selectedKondisi.value}');
  }

  // BARU - Method untuk mapping kondisi dari model ke dropdown
  String? mapKondisiFromModel(String? kondisi) {
    switch (kondisi?.toLowerCase()) {
      case 'aktif':
      case 'baik':
        return 'good';
      case 'rusak':
      case 'broken':
        return 'broken';
      default:
        return null;
    }
  }

// BARU - Method untuk mapping kondisi dari dropdown ke model
  String? mapKondisiToModel(String? kondisi) {
    switch (kondisi) {
      case 'good':
        return 'good';
      case 'broken':
        return 'broken';
      default:
        return kondisi;
    }
  }

  // Pick image
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
      imageError.value = '';
    }
  }

  // Validate & update
  void validateForm() async {
    bool isValid = true;

    if (namaController.text.isEmpty) {
      namaError.value = "Nama tidak boleh kosong";
      isValid = false;
    } else {
      namaError.value = "";
    }

    if (lokasiController.text.isEmpty) {
      lokasiError.value = "Lokasi tidak boleh kosong";
      isValid = false;
    } else {
      lokasiError.value = "";
    }

    if (detailLokasiController.text.isEmpty) {
      detailLokasiError.value = "Detail lokasi tidak boleh kosong";
      isValid = false;
    } else {
      detailLokasiError.value = "";
    }

    if (selectedType.value == null) {
      Get.snackbar("Error", "Tipe alat harus dipilih");
      isValid = false;
    }

    if (selectedKondisi.value == null) {
      Get.snackbar("Error", "Kondisi alat harus dipilih");
      isValid = false;
    }

    if (isValid) {
      await updateAlat();
    }
  }

  // API call
  Future<void> updateAlat() async {
    isLoading.value = true;

    final alat = AlatModel(
      id: currentAlat.id,
      namaAlat: namaController.text,
      lokasi: lokasiController.text,
      detailLokasi: detailLokasiController.text,
      pestType: selectedType.value!,
      kondisi: selectedKondisi.value!,
      kodeQr: currentAlat.kodeQr,
      imagePath: currentAlat.imagePath,
    );

    final response = await AlatService.updateAlat(
      alat.id!,
      alat,
      imageFile: imageFile.value,
    );

    isLoading.value = false;

    if (response != null && response.statusCode == 200) {
      Get.snackbar("Sukses", "Data alat berhasil diupdate");
      Get.offNamed('/detailtool'); // Navigasi balik
    } else {
      Get.snackbar("Gagal", "Gagal memperbarui data alat");
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    lokasiController.dispose();
    detailLokasiController.dispose();
    super.onClose();
  }
}
