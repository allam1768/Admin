import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/company_model.dart';
import '../../../../data/services/company_service.dart';
import '../../../../data/services/client_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';
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

  // Data dari form client sebelumnya
  late String clientName;
  late String clientEmail;
  late String clientPhone;
  late String clientPassword;
  File? clientProfileImage;

  @override
  void onInit() {
    super.onInit();
    // Ambil data dari arguments yang dikirim dari CreateAccountClient
    final arguments = Get.arguments;
    if (arguments != null) {
      clientName = arguments['name'] ?? '';
      clientEmail = arguments['email'] ?? '';
      clientPhone = arguments['phone'] ?? '';
      clientPassword = arguments['password'] ?? '';
      clientProfileImage = arguments['profileImage'];
    }
  }

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
      createClientAndCompany();
    }
  }

  // Fungsi untuk membuat client dan company sekaligus
  Future<void> createClientAndCompany() async {
    try {
      isLoading.value = true;

      // Step 1: Buat client terlebih dahulu
      print('🔄 Step 1: Creating client...');
      final clientResponse = await ClientService.createClient(
        username: clientName,
        email: clientEmail,
        phoneNumber: clientPhone,
        password: clientPassword,
        profileImage: clientProfileImage,
      );

      if (!clientResponse.success || clientResponse.user == null) {
        throw Exception('Gagal membuat client: ${clientResponse.message}');
      }

      print('✅ Client created successfully');
      print('Client ID: ${clientResponse.user!.id}');
      print('Client Name: ${clientResponse.user!.name}');

      // Step 2: Buat company dengan client ID yang baru dibuat
      print('🔄 Step 2: Creating company...');

      // Generate QR unik untuk company
      String qrContent = generateUniqueQrCode();

      // Buat company dengan client ID dari response client
      CompanyModel createdCompany = await _companyService.createCompanyWithImage(
        name: name.value,
        address: address.value,
        phoneNumber: phoneNumber.value,
        email: email.value,
        imageFile: imageFile.value,
        clientId: clientResponse.user!.id.toString(), // Gunakan ID dari client yang baru dibuat
        companyQr: qrContent,
      );

      print('✅ Company created successfully');
      print('Company ID: ${createdCompany.id}');
      print('Company QR: ${createdCompany.companyQr}');

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Success',
        'Client dan Company berhasil dibuat!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Gunakan QR code dari response server (jika ada) atau yang kita generate
      String finalQrContent = createdCompany.companyQr ?? qrContent;

      // Navigasi ke tampilan QR dengan data yang lengkap
      Get.off(() => QrCompanyView(
          qrData: finalQrContent
      ));

    } catch (e) {
      // Tampilkan pesan error
      Get.snackbar(
        'Error',
        'Gagal membuat client dan company: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      print('❌ Error creating client and company: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk membuat company saja (untuk backward compatibility)
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

  // Fungsi untuk kembali ke dashboard
  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 1;
    Get.offNamed('/bottomnav');
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