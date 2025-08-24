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
import '../../Client/Create Account Client/create_account_client_controller.dart';
import '../Qr Company Screen/qr_company_view.dart';

// Custom exception class untuk client creation error
class ClientCreationException implements Exception {
  final String message;
  ClientCreationException(this.message);

  @override
  String toString() => message;
}

class CreateQrCompanyController extends GetxController {
  // TextEditingControllers untuk field input
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

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
        // Jika error terjadi di bagian create client
        throw ClientCreationException('Gagal membuat client: ${clientResponse.message}');
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

      // Clear semua form setelah berhasil
      clearAllFields();

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

    } on ClientCreationException catch (e) {
      // Error khusus untuk client creation - kembali ke halaman create client
      _handleClientError(e.message);
    } catch (e) {
      // Error umum lainnya (company creation, network, dll)
      _handleGeneralError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk handle error khusus client creation
  void _handleClientError(String errorMessage) {
    // Tampilkan dialog error dengan opsi kembali ke create client
    Get.dialog(
      AlertDialog(
        title: Text(
          'Error Create Client',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terjadi kesalahan saat membuat client:',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade800,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Silakan periksa data client dan coba lagi.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              goToDashboard(); // Kembali ke dashboard
            },
            child: Text(
              'Dashboard',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              // Kembali ke halaman create client dengan data yang sudah ada
              _backToCreateClient();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Kembali ke Create Client'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Fungsi untuk handle error umum
  void _handleGeneralError(String errorMessage) {
    Get.snackbar(
      'Error',
      'Gagal membuat client dan company: $errorMessage',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
    print('⚠️ Error creating client and company: $errorMessage');
  }

  // Fungsi untuk kembali ke create client dengan data yang ada
  void _backToCreateClient() {
    // Kembali ke halaman create client dan isi data yang sudah ada
    Get.offNamed('/CreateAccountClient');

    // Tunggu sebentar untuk memastikan halaman sudah ter-load
    Future.delayed(Duration(milliseconds: 500), () {
      try {
        // Ambil controller create client dan isi dengan data yang ada
        final clientController = Get.find<CreateAccountClientController>();

        // Isi form dengan data yang sudah ada
        clientController.nameController.text = clientName;
        clientController.emailController.text = clientEmail;
        clientController.phoneController.text = clientPhone;
        clientController.passwordController.text = clientPassword;
        clientController.confirmPasswordController.text = clientPassword;

        // Set profile image jika ada
        if (clientProfileImage != null) {
          clientController.profileImage.value = clientProfileImage;
        }

        // Clear error messages
        clientController.nameError.value = null;
        clientController.emailError.value = null;
        clientController.phoneError.value = null;
        clientController.passwordError.value = null;
        clientController.confirmPasswordError.value = null;
        clientController.imageError.value = false;

        print('✨ Client form restored with existing data');

        // Tampilkan snackbar informasi
        Get.snackbar(
          'Info',
          'Data client telah dipulihkan. Silakan periksa dan coba lagi.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

      } catch (e) {
        print('❗ Could not restore client data: $e');
        // Jika gagal mengambil controller, tampilkan pesan
        Get.snackbar(
          'Info',
          'Silakan isi ulang data client.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    });
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

      // Clear semua form setelah berhasil
      clearAllFields();

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

  // Fungsi untuk clear semua field dan image (termasuk client form)
  void clearAllFields() {
    // Clear company form reactive variables
    name.value = "";
    address.value = "";
    phoneNumber.value = "";
    email.value = "";
    imageFile.value = null;

    // Clear company form text controllers
    nameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();

    // Clear company form error messages
    nameError.value = "";
    addressError.value = "";
    phoneError.value = "";
    emailError.value = "";
    imageError.value = false;

    // Clear client form juga jika masih ada
    try {
      final clientController = Get.find<CreateAccountClientController>();
      clientController.clearAllFields();
      print('✨ Client form cleared successfully');
    } catch (e) {
      print('ℹ️ Client controller not found, might be already disposed');
    }

    print('✨ All company fields cleared successfully');
  }

  // Reset form (alias untuk clearAllFields untuk backward compatibility)
  void clearForm() {
    clearAllFields();
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is destroyed
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}