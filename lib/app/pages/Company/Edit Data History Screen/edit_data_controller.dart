import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class EditDataController extends GetxController {
  // Observable variables for form fields
  final selectedCondition = "".obs;
  final jumlah = "".obs;
  final jenisHama = "".obs;
  final catatan = "".obs;

  // Error messages
  final conditionError = "".obs;
  final jumlahError = "".obs;
  final jenisHamaError = "".obs;
  final catatanError = "".obs;
  final imageError = false.obs;

  // Image handling
  final Rx<File?> imageFile = Rx<File?>(null);
  final currentImageUrl = "".obs;

  // Loading and data states
  final isLoading = false.obs;
  final isSaving = false.obs;
  final catchData = <String, dynamic>{}.obs;
  final catchId = 0.obs;

  // --- UPDATED FOR DROPDOWN ---
  final pestOptions = <String>[
    'Kecoa',
    'Tikus',
    'Nyamuk',
    'Lalat',
    'Phorids',
    'Ngengat',
    'Capung',
    'Kupu-Kupu',
  ].obs;
  final selectedPest = ''.obs;
  final customPestText = ''.obs; // Separate variable for custom input
  final showCustomPestField = false.obs;
  // --- END UPDATED FOR DROPDOWN ---

  // API constants
  static const String baseUrl = 'https://hamatech.rplrus.com';
  late final http.Client _httpClient;

  @override
  void onInit() {
    super.onInit();
    _httpClient = http.Client();
    loadInitialData();
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }

  /// Load initial data from arguments
  void loadInitialData() {
    final arguments = Get.arguments;

    if (arguments != null && arguments is Map<String, dynamic>) {
      catchData.value = arguments;
      catchId.value = arguments['id'] ?? 0;

      // Pre-fill form with existing data
      _populateFormFromData(arguments);
    } else {
      _showErrorSnackbar('No data received for editing');
      Get.back();
    }
  }

  /// Populate form fields with existing data
  void _populateFormFromData(Map<String, dynamic> data) {
    // Set condition - convert from Indonesian to English for internal use
    String condition = data['kondisi']?.toString() ?? '';
    switch (condition.toLowerCase()) {
      case 'baik':
      case 'good':
        selectedCondition.value = 'Good';
        break;
      case 'rusak':
      case 'broken':
        selectedCondition.value = 'Broken';
        break;
      case 'maintenance':
        selectedCondition.value = 'Maintenance';
        break;
      default:
      // If condition is already in English, keep it
        if (condition.isNotEmpty) {
          selectedCondition.value = condition.substring(0, 1).toUpperCase() +
              condition.substring(1).toLowerCase();
        }
    }

    jumlah.value = data['jumlah']?.toString() ?? '';
    jenisHama.value = data['jenis_hama']?.toString() ?? '';
    catatan.value = data['catatan']?.toString() ?? '';

    // --- UPDATED POPULATE FOR DROPDOWN ---
    // Check if the existing jenisHama is in the predefined list
    if (jenisHama.value.isNotEmpty) {
      if (pestOptions.contains(jenisHama.value)) {
        selectedPest.value = jenisHama.value;
        showCustomPestField.value = false;
      } else {
        selectedPest.value = 'Other';
        customPestText.value = jenisHama.value;
        showCustomPestField.value = true;
      }
    }
    // --- END UPDATED POPULATE FOR DROPDOWN ---

    // Set current image URL - handle multiple possible keys
    String? imageUrl;

    if (data['image_url'] != null && data['image_url'].toString().isNotEmpty) {
      imageUrl = data['image_url'].toString();
    } else if (data['foto_dokumentasi'] != null && data['foto_dokumentasi'].toString().isNotEmpty) {
      String fotoPath = data['foto_dokumentasi'].toString();
      // Check if it's already a full URL or just a path
      if (fotoPath.startsWith('http')) {
        imageUrl = fotoPath;
      } else {
        imageUrl = '$baseUrl/storage/$fotoPath';
      }
    }

    if (imageUrl != null) {
      currentImageUrl.value = imageUrl;
      print('DEBUG: Set current image URL: $imageUrl'); // Debug log
    }
  }

  /// Set condition value
  void setCondition(String? value) {
    if (value != null) {
      selectedCondition.value = value;
      conditionError.value = ""; // Clear error when user selects
    }
  }

  /// Set jumlah value
  void setJumlah(String value) {
    jumlah.value = value;
    jumlahError.value = ""; // Clear error when user types
  }

  /// Method for dropdown selection
  void setSelectedPest(String value) {
    selectedPest.value = value;
    if (!showCustomPestField.value) {
      jenisHama.value = value;
    }
    jenisHamaError.value = ""; // Clear error when user selects
  }

  /// Method for custom pest input
  void setCustomPestText(String value) {
    customPestText.value = value;
    jenisHama.value = value;
    jenisHamaError.value = ""; // Clear error when user types
  }

  /// Get the final pest value (either from dropdown or custom input)
  String get finalPestValue {
    if (showCustomPestField.value) {
      return customPestText.value;
    } else {
      return selectedPest.value;
    }
  }

  /// Set jenis hama value (keeping for backward compatibility)
  void setJenisHama(String value) {
    jenisHama.value = value;
    jenisHamaError.value = ""; // Clear error when user types
  }

  /// Set catatan value
  void setCatatan(String value) {
    catatan.value = value;
    catatanError.value = ""; // Clear error when user types
  }

  /// Take picture from camera
  Future<void> takePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        imageError.value = false;
        _showSuccessSnackbar('New image captured');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to capture image: ${e.toString()}');
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        imageError.value = false;
        _showSuccessSnackbar('Image selected from gallery');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick image: ${e.toString()}');
    }
  }

  /// Validate form before submission
  bool _validateForm() {
    bool isValid = true;

    // Clear all errors first
    conditionError.value = "";
    jumlahError.value = "";
    jenisHamaError.value = "";
    catatanError.value = "";
    imageError.value = false;

    // Validate condition
    if (selectedCondition.value.isEmpty) {
      conditionError.value = "Kondisi harus dipilih!";
      isValid = false;
    }

    // Validate jumlah
    if (jumlah.value.isEmpty) {
      jumlahError.value = "Jumlah harus diisi!";
      isValid = false;
    } else {
      // Check if it's a valid number
      final numValue = int.tryParse(jumlah.value);
      if (numValue == null || numValue <= 0) {
        jumlahError.value = "Jumlah harus berupa angka positif!";
        isValid = false;
      }
    }

    // Validate jenis hama using finalPestValue
    if (finalPestValue.isEmpty) {
      jenisHamaError.value = "Jenis hama harus diisi!";
      isValid = false;
    }

    // Validate catatan
    if (catatan.value.isEmpty) {
      catatanError.value = "Catatan harus diisi!";
      isValid = false;
    }

    return isValid;
  }

  /// Convert condition from English to Indonesian for API
  String _getConditionForAPI(String condition) {
    switch (condition.toLowerCase()) {
      case 'good':
        return 'good';
      case 'broken':
        return 'broken';
      case 'maintenance':
        return 'maintenance';
      default:
        return condition.toLowerCase();
    }
  }

  /// Save/Update catch data
  Future<void> saveCatch() async {
    if (!_validateForm()) {
      _showErrorSnackbar('Please fix the errors above');
      return;
    }

    if (catchId.value <= 0) {
      _showErrorSnackbar('Invalid catch ID');
      return;
    }

    try {
      isSaving.value = true;

      // Prepare form data
      Map<String, String> fields = {
        'kondisi': _getConditionForAPI(selectedCondition.value),
        'jumlah': jumlah.value,
        'jenis_hama': finalPestValue, // Use finalPestValue instead of jenisHama.value
        'catatan': catatan.value,
      };

      http.Response response;

      if (imageFile.value != null) {
        // Update with new image
        response = await _updateCatchWithImage(fields, imageFile.value!.path);
      } else {
        // Update without changing image
        response = await _updateCatchTextOnly(fields);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        _showSuccessSnackbar('Data berhasil diperbarui!');

        await Future.delayed(const Duration(seconds: 1));

        Get.back(result: {
          'updated': true,
          'data': responseData['data'],
        });

      } else {
        final errorData = jsonDecode(response.body);
        _showErrorSnackbar('Gagal memperbarui data: ${errorData['message'] ?? 'Server error'}');
      }

    } catch (e) {
      _showErrorSnackbar('Error: ${e.toString()}');
    } finally {
      isSaving.value = false;
    }
  }

  /// Update catch with new image
  Future<http.Response> _updateCatchWithImage(Map<String, String> fields, String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/catches/${catchId.value}'),
    );

    request.fields['_method'] = 'PUT';
    request.fields.addAll(fields);

    var imageFile = await http.MultipartFile.fromPath(
      'foto_dokumentasi',
      imagePath,
    );
    request.files.add(imageFile);

    var streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );

    return await http.Response.fromStream(streamedResponse);
  }

  /// Update catch text fields only
  Future<http.Response> _updateCatchTextOnly(Map<String, String> fields) async {
    return await _httpClient.put(
      Uri.parse('$baseUrl/api/catches/${catchId.value}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(fields),
    ).timeout(const Duration(seconds: 15));
  }

  /// Get current image to display
  String getCurrentImageUrl() {
    if (imageFile.value != null) {
      return imageFile.value!.path;
    }
    if (currentImageUrl.value.isNotEmpty) {
      return currentImageUrl.value;
    }
    return '';
  }

  /// Check if there's a new image selected
  bool hasNewImage() {
    return imageFile.value != null;
  }

  /// Check if there's an existing image
  bool hasExistingImage() {
    return currentImageUrl.value.isNotEmpty;
  }

  /// Remove selected new image (revert to original)
  void removeNewImage() {
    imageFile.value = null;
    imageError.value = false;
  }

  /// Debug method to check image state
  void debugImageState() {
    print('=== IMAGE STATE DEBUG ===');
    print('Has new image: ${hasNewImage()}');
    print('Has existing image: ${hasExistingImage()}');
    print('Current image URL: ${currentImageUrl.value}');
    print('New image file: ${imageFile.value?.path}');
    print('Current display URL: ${getCurrentImageUrl()}');
    print('========================');
  }

  /// Helper methods for showing snackbars
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}