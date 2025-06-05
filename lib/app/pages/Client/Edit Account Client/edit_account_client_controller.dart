import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/models/client_model.dart';
import '../../../../data/services/client_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class EditAccountClientController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var profileImage = Rx<File?>(null);
  var imageError = false.obs;
  var isLoading = false.obs;
  var hasChanges = false.obs;

  var nameError = RxnString();
  var phoneError = RxnString();
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();

  // Data client yang sedang diedit
  ClientModel? currentClient;
  String? clientId;

  // Original data untuk detect perubahan
  String _originalName = '';
  String _originalEmail = '';
  String _originalPhone = '';

  bool get canSave => hasChanges.value && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      currentClient = arguments['client'] as ClientModel?;
      clientId = arguments['clientId']?.toString();

      if (currentClient != null) {
        _loadClientData();
      }
    }

    // Listen to text field changes
    _setupTextFieldListeners();

    // Listen to profile image changes
    profileImage.listen((_) => _checkForChanges());
  }

  void _loadClientData() {
    if (currentClient != null) {
      _originalName = currentClient!.name ?? '';
      _originalEmail = currentClient!.email ?? '';
      _originalPhone = currentClient!.phoneNumber ?? '';

      nameController.text = _originalName;
      emailController.text = _originalEmail;
      phoneController.text = _originalPhone;

      // Password tidak diisi untuk keamanan
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }

  void _setupTextFieldListeners() {
    nameController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    passwordController.addListener(_checkForChanges);
    confirmPasswordController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final nameChanged = nameController.text.trim() != _originalName;
    final phoneChanged = phoneController.text.trim() != _originalPhone;
    final emailChanged = emailController.text.trim() != _originalEmail;
    final passwordFilled = passwordController.text.trim().isNotEmpty ||
        confirmPasswordController.text.trim().isNotEmpty;
    final imageChanged = profileImage.value != null;

    hasChanges.value = nameChanged ||
        phoneChanged ||
        emailChanged ||
        passwordFilled ||
        imageChanged;
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (picked != null) {
        profileImage.value = File(picked.path);
        imageError.value = false;
        // _checkForChanges() akan dipanggil otomatis karena listener

        Get.snackbar(
          'Success',
          'Image selected successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void validateForm() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Reset error messages
    nameError.value = null;
    phoneError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    bool hasError = false;

    // Validate name
    if (name.isEmpty) {
      nameError.value = 'Name is required';
      hasError = true;
    }

    // Validate phone number
    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      hasError = true;
    } else if (!_isValidPhoneNumber(phone)) {
      phoneError.value = 'Invalid phone number format';
      hasError = true;
    }

    // Validate email
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      hasError = true;
    } else if (!_isValidEmail(email)) {
      emailError.value = 'Invalid email format';
      hasError = true;
    }

    // Validate password if provided
    if (password.isNotEmpty || confirmPassword.isNotEmpty) {
      if (password.length < 6) {
        passwordError.value = 'Password must be at least 6 characters';
        hasError = true;
      }
      if (confirmPassword.isEmpty) {
        confirmPasswordError.value = 'Confirm password is required';
        hasError = true;
      } else if (password != confirmPassword) {
        confirmPasswordError.value = 'Passwords do not match';
        hasError = true;
      }
    }

    if (!hasError) {
      await updateClient();
    }
  }

  Future<void> updateClient() async {
    if (clientId == null) {
      Get.snackbar(
        'Error',
        'Client ID not found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Hanya kirim email jika benar-benar berubah
      String? emailToSend;
      if (emailController.text.trim() != _originalEmail) {
        emailToSend = emailController.text.trim();
      }

      final response = await ClientService.updateClient(
        clientId: clientId!,
        name: nameController.text.trim(),
        email: emailToSend, // Kirim null jika tidak berubah
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text.trim().isNotEmpty
            ? passwordController.text.trim()
            : null,
        profileImage: profileImage.value,
      );

      if (response != null && response.success) {
        // Update original data after successful update
        _originalName = nameController.text.trim();
        _originalEmail = emailController.text.trim();
        _originalPhone = phoneController.text.trim();
        profileImage.value = null; // Reset image after successful upload
        passwordController.clear();
        confirmPasswordController.clear();
        _checkForChanges(); // Recheck changes

        Get.snackbar(
          'Success',
          response.message ?? 'Client updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.find<BottomNavController>().selectedIndex.value = 1;
        Get.offNamed('/bottomnav');
      } else {
        Get.snackbar(
          'Error',
          response?.message ?? 'Failed to update client',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    // Indonesian phone number validation
    return RegExp(r'^(\+62|62|0)[0-9]{9,13}$').hasMatch(phone);
  }

  void clearPassword() {
    passwordController.clear();
    confirmPasswordController.clear();
    passwordError.value = null;
    confirmPasswordError.value = null;
    _checkForChanges();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}