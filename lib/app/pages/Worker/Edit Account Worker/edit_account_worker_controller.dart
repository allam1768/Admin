import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/worker_model.dart';
import '../../../../data/services/worker_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';
import '../Account Worker/account_worker_controller.dart';

class EditAccountWorkerController extends GetxController {
  // Observable variables
  var name = "".obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var showError = false.obs;
  var profileImage = Rx<File?>(null);
  var isLoading = false.obs;

  // Variable untuk menyimpan data asli
  var originalName = "";
  var originalPhoneNumber = "";
  var originalEmail = "";
  var originalImageUrl = "";

  // Worker data yang akan diedit
  WorkerModel? currentWorker;

  // Service untuk API calls
  final WorkerService _workerService = WorkerService();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadWorkerData();
  }

  void _loadWorkerData() {
    try {
      // Ambil data worker dari arguments
      final WorkerModel? worker = Get.arguments as WorkerModel?;

      if (worker != null) {
        currentWorker = worker;

        // Pre-fill form dengan data yang ada
        name.value = worker.name ?? "";
        email.value = worker.email ?? "";
        phoneNumber.value = worker.phoneNumber ?? "";

        // Simpan data asli untuk perbandingan
        originalName = worker.name ?? "";
        originalEmail = worker.email ?? "";
        originalPhoneNumber = worker.phoneNumber ?? "";
        originalImageUrl = worker.image ?? "";

        // Note: Password tidak di-fill karena alasan keamanan
        password.value = "";
        confirmPassword.value = "";

        print('Worker data loaded: ${worker.toString()}');
      } else {
        print('No worker data found in arguments');
        Get.snackbar(
          'Error',
          'Data worker tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error loading worker data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data worker: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method untuk cek apakah ada perubahan data
  bool get hasDataChanged {
    bool nameChanged = name.value.trim() != originalName;
    bool emailChanged = email.value.trim() != originalEmail;
    bool phoneChanged = phoneNumber.value.trim() != originalPhoneNumber;
    bool passwordChanged = password.value.trim().isNotEmpty;
    bool imageChanged = profileImage.value != null;

    return nameChanged || emailChanged || phoneChanged || passwordChanged || imageChanged;
  }

  // Method untuk cek apakah tombol save bisa ditekan
  bool get canSave {
    return hasDataChanged && isFormValid() && !isLoading.value;
  }

  // Method untuk memilih gambar dari galeri
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Gambar berhasil dipilih',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method untuk mengambil gambar dari kamera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Foto berhasil diambil',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error taking photo: $e');
      Get.snackbar(
        'Error',
        'Gagal mengambil foto: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method untuk validasi form
  void validateForm() {
    showError.value = true;

    // Cek apakah ada perubahan data
    if (!hasDataChanged) {
      Get.snackbar(
        'Info',
        'Tidak ada perubahan data untuk disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Jika validasi berhasil, panggil updateWorker
    if (isFormValid()) {
      updateWorker();
    } else {
      print('Form validation failed');
      // Tampilkan pesan error spesifik
      if (name.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Nama harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (email.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Email harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (!isValidEmail(email.value)) {
        Get.snackbar(
          'Error',
          'Format email tidak valid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (phoneNumber.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Nomor telepon harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (password.value.isNotEmpty && password.value.length < 6) {
        Get.snackbar(
          'Error',
          'Password minimal 6 karakter',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (password.value.isNotEmpty && password.value != confirmPassword.value) {
        Get.snackbar(
          'Error',
          'Password tidak cocok',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Method untuk cek apakah form valid
  bool isFormValid() {
    bool valid = name.value.isNotEmpty &&
        phoneNumber.value.isNotEmpty &&
        email.value.isNotEmpty &&
        isValidEmail(email.value) &&
        (password.value.isEmpty || password.value.length >= 6) &&
        (password.value.isEmpty || password.value == confirmPassword.value);

    print('Form validation: $valid');
    print('Name: "${name.value}"');
    print('Phone: "${phoneNumber.value}"');
    print('Email: "${email.value}"');
    print('Password: "${password.value}"');
    print('Confirm Password: "${confirmPassword.value}"');

    return valid;
  }

  // Method untuk validasi email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Method untuk update worker
  Future<void> updateWorker() async {
    if (currentWorker == null) {
      print('Current worker is null');
      Get.snackbar(
        'Error',
        'Data worker tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      print('Starting worker update...');
      print('Worker ID: ${currentWorker!.id}');
      print('Current worker email: ${currentWorker!.email}');
      print('New email: ${email.value}');

      // Cek apakah data berubah dari data asli
      String? nameToUpdate = (name.value.trim() != currentWorker!.name) ? name.value.trim() : null;
      String? emailToUpdate = (email.value.trim() != currentWorker!.email) ? email.value.trim() : null;
      String? phoneToUpdate = (phoneNumber.value.trim() != currentWorker!.phoneNumber) ? phoneNumber.value.trim() : null;
      String? passwordToUpdate = password.value.trim().isNotEmpty ? password.value.trim() : null;

      print('Update data: name=$nameToUpdate, email=$emailToUpdate, phone=$phoneToUpdate, hasPassword=${passwordToUpdate != null}');

      // Panggil service untuk update worker
      final result = await _workerService.updateWorker(
        workerId: currentWorker!.id.toString(),
        name: nameToUpdate,
        email: emailToUpdate,
        phoneNumber: phoneToUpdate,
        password: passwordToUpdate,
        profileImage: profileImage.value,
      );

      print('Update result: ${result.success}');
      print('Update message: ${result.message}');

      if (result.success) {
        Get.snackbar(
          'Success',
          result.message ?? 'Worker berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Update data di AccountWorkerController jika ada
        try {
          final accountController = Get.find<AccountWorkerController>();
          if (result.user != null) {
            // Update dengan data baru dari server
            final updatedWorker = WorkerModel.fromJson(result.user!.toJson());
            accountController.workerData.value = updatedWorker;
            accountController.userName.value = updatedWorker.name;
            accountController.userEmail.value = updatedWorker.displayEmail;
            accountController.fullName.value = updatedWorker.name;
            accountController.phoneNumber.value = updatedWorker.displayPhoneNumber;
            accountController.userImage.value = updatedWorker.image ?? "";

            print('AccountWorkerController updated successfully');
          }
        } catch (e) {
          print('Error updating AccountWorkerController: $e');
          // Tidak perlu menampilkan error ini ke user
        }

        Get.find<BottomNavController>().selectedIndex.value = 2;
        Get.offNamed('/bottomnav');
      } else {
        // Tampilkan pesan error dari server
        Get.snackbar(
          'Error',
          result.message ?? 'Gagal memperbarui worker',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      print('Error updating worker: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memperbarui worker: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk cek error pada field tertentu
  bool hasError(String field) {
    if (!showError.value) return false;

    switch (field) {
      case "Name":
        return name.value.trim().isEmpty;
      case "Phone number":
        return phoneNumber.value.trim().isEmpty;
      case "Email":
        return email.value.trim().isEmpty || !isValidEmail(email.value.trim());
      case "Password":
        return password.value.isNotEmpty && password.value.length < 6;
      case "Confirm Password":
        return password.value.isNotEmpty &&
            (confirmPassword.value.isEmpty ||
                password.value != confirmPassword.value);
      default:
        return false;
    }
  }

  // Method untuk mendapatkan pesan error
  String? getErrorMessage(String field) {
    if (!hasError(field)) return null;

    switch (field) {
      case "Name":
        return "Nama harus diisi!";
      case "Phone number":
        return "Nomor telepon harus diisi!";
      case "Email":
        if (email.value.trim().isEmpty) {
          return "Email harus diisi!";
        } else if (!isValidEmail(email.value.trim())) {
          return "Format email tidak valid!";
        }
        break;
      case "Password":
        if (password.value.isNotEmpty && password.value.length < 6) {
          return "Password minimal 6 karakter!";
        }
        break;
      case "Confirm Password":
        if (password.value.isNotEmpty) {
          if (confirmPassword.value.isEmpty) {
            return "Konfirmasi password harus diisi!";
          } else if (password.value != confirmPassword.value) {
            return "Password tidak cocok!";
          }
        }
        break;
      default:
        return "$field harus diisi!";
    }
    return null;
  }

  // Method untuk reset form
  void resetForm() {
    name.value = "";
    phoneNumber.value = "";
    email.value = "";
    password.value = "";
    confirmPassword.value = "";
    profileImage.value = null;
    showError.value = false;
  }

  // Method untuk kembali tanpa menyimpan
  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    // Cleanup jika diperlukan
    super.onClose();
  }
}