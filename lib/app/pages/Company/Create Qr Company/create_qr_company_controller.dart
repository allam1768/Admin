import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/company_model.dart';
import '../../../../data/services/company_service.dart';
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
  RxBool isLoading = false.obs;

  final CompanyService _companyService = CompanyService();

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false;
    }
  }

  // Fungsi untuk validasi form
  void validateForm() {
    bool isValid = true;

    // Reset error messages
    nameError.value = "";
    addressError.value = "";
    phoneError.value = "";
    emailError.value = "";
    imageError.value = false;

    // Validasi input
    if (name.value.isEmpty) {
      nameError.value = "Name Company harus diisi!";
      isValid = false;
    }

    if (address.value.isEmpty) {
      addressError.value = "Address Company harus diisi!";
      isValid = false;
    }

    if (phoneNumber.value.isEmpty) {
      phoneError.value = "Phone number harus diisi!";
      isValid = false;
    }

    if (email.value.isEmpty) {
      emailError.value = "Email Company harus diisi!";
      isValid = false;
    } else if (!GetUtils.isEmail(email.value)) {
      emailError.value = "Format email tidak valid!";
      isValid = false;
    }

    // Validasi gambar (opsional, tergantung requirement)
    if (imageFile.value == null) {
      imageError.value = true;
      // Uncomment jika gambar wajib diisi
      // isValid = false;
    }

    if (isValid) {
      createCompany();
    }
  }

  // Fungsi untuk membuat company dan generate QR dengan multipart
  Future<void> createCompany() async {
    try {
      isLoading.value = true;

      // Generate QR unik untuk dikirim ke server
      String qrContent = generateUniqueQrCode();

      // Gunakan multipart request untuk mengirim gambar dan QR code
      CompanyModel createdCompany = await _companyService.createCompanyWithImage(
        name: name.value,
        address: address.value,
        phoneNumber: phoneNumber.value,
        email: email.value,
        imageFile: imageFile.value,
        companyQr: qrContent, // Kirim QR code yang sudah dibuat
      );

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Success',
        'Company berhasil dibuat!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Gunakan QR code dari response server (jika ada) atau yang kita generate
      String finalQrContent = createdCompany.companyQr ?? qrContent;

      print('Company created successfully:');
      print('Company ID: ${createdCompany.id}');
      print('Company QR: ${createdCompany.companyQr}');
      print('Client Info: ${createdCompany.client?.name} (${createdCompany.client?.email})');

      // Navigasi ke tampilan QR dengan data yang lengkap
      Get.off(() => QrCompanyView(
        qrData: finalQrContent
      ));
    } catch (e) {
      // Tampilkan pesan error
      Get.snackbar(
        'Error',
        'Gagal membuat company: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      print('Error creating company: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk menghasilkan QR unik
  String generateUniqueQrCode() {
    const prefix = "company-";
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    final randomCode = List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
    return "$prefix$randomCode";
  }

  // Reset form
  void clearForm() {
    name.value = "";
    address.value = "";
    phoneNumber.value = "";
    email.value = "";
    imageFile.value = null;

    nameError.value = "";
    addressError.value = "";
    phoneError.value = "";
    emailError.value = "";
    imageError.value = false;
  }
}