import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportInputController extends GetxController {
  RxString amount = "".obs;  // area field
  RxString information = "".obs;
  RxString areaError = RxString("");
  RxString informationError = RxString("");
  Rx<File?> imageFile = Rx<File?>(null);
  RxBool imageError = false.obs;
  RxBool isLoading = false.obs;

  // API configuration
  static const String baseUrl = "https://hamatech.rplrus.com/api";
  static const String reportEndpoint = "/reports";

  @override
  void onInit() {
    super.onInit();
    print("🔧 ReportInputController initialized");
  }

  Future<void> takePicture() async {
    print("📸 Taking picture from camera...");
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        imageError.value = false;
        print("✅ Picture taken successfully: ${pickedFile.path}");
        print("📁 Image file size: ${await imageFile.value!.length()} bytes");
      } else {
        print("❌ No picture was taken");
      }
    } catch (e) {
      print("❌ Error taking picture: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    print("🖼️ Picking image from gallery...");
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        imageError.value = false;
        print("✅ Image picked successfully: ${pickedFile.path}");
        print("📁 Image file size: ${await imageFile.value!.length()} bytes");
      } else {
        print("❌ No image was selected");
      }
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  void validateForm() {
    print("🔍 Starting form validation...");

    // Reset error messages
    areaError.value = "";
    informationError.value = "";
    imageError.value = false;

    print("📋 Form data:");
    print("  - Area: '${amount.value}' (isEmpty: ${amount.value.isEmpty})");
    print("  - Information: '${information.value}' (isEmpty: ${information.value.isEmpty})");
    print("  - Image file: ${imageFile.value != null ? 'Selected' : 'Not selected'}");

    // Validate each field
    if (amount.value.isEmpty) {
      areaError.value = "Area harus diisi!";
      print("❌ Area validation failed: empty");
    } else {
      print("✅ Area validation passed");
    }

    if (information.value.isEmpty) {
      informationError.value = "Information harus diisi!";
      print("❌ Information validation failed: empty");
    } else {
      print("✅ Information validation passed");
    }

    if (imageFile.value == null) {
      imageError.value = true;
      print("❌ Image validation failed: no image selected");
    } else {
      print("✅ Image validation passed");
    }

    // Check if form is valid
    bool isValid = amount.value.isNotEmpty &&
        information.value.isNotEmpty &&
        imageFile.value != null;

    print("📊 Form validation result: ${isValid ? 'VALID' : 'INVALID'}");

    if (isValid) {
      print("🚀 Form is valid, proceeding to submit report...");
      submitReport();
    } else {
      print("⚠️ Form is invalid, showing validation errors");
    }
  }

  Future<void> submitReport() async {
    if (isLoading.value) {
      print("⏳ Already loading, skipping submit request");
      return;
    }

    print("📤 Starting report submission...");
    print("🌐 API URL: $baseUrl$reportEndpoint");

    try {
      isLoading.value = true;
      print("🔄 Loading state set to true");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$reportEndpoint'),
      );

      // Add text fields
      request.fields['nama_pengirim'] = 'Worker App User';
      request.fields['area'] = amount.value;
      request.fields['informasi'] = information.value;
      request.fields['company_id'] = '1';

      print("📝 Request fields added:");
      print("  - nama_pengirim: Worker App User");
      print("  - area: ${amount.value}");
      print("  - informasi: ${information.value}");
      print("  - company_id: 1");

      // Add image file if exists
      if (imageFile.value != null) {
        print("🖼️ Adding image file to request...");
        var imageStream = http.ByteStream(imageFile.value!.openRead());
        var imageLength = await imageFile.value!.length();
        var multipartFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: 'report_image.jpg',
        );
        request.files.add(multipartFile);
        print("✅ Image file added - Size: $imageLength bytes, Filename: report_image.jpg");
      } else {
        print("⚠️ No image file to add");
      }

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      print("📋 Request headers added:");
      request.headers.forEach((key, value) {
        print("  - $key: $value");
      });

      print("🌐 Sending request...");
      var response = await request.send();
      print("📨 Response received - Status Code: ${response.statusCode}");

      var responseBody = await response.stream.bytesToString();
      print("📄 Response body: $responseBody");

      var jsonResponse = json.decode(responseBody);
      print("📊 Parsed JSON response: $jsonResponse");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ HTTP request successful (${response.statusCode})");

        if (jsonResponse['success'] == true) {
          print("🎉 API response indicates success");

          Get.rawSnackbar(
            message: jsonResponse['message'] ?? "Data berhasil disimpan",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(16),
            borderRadius: 8,
          );

          print("📋 Success message shown: ${jsonResponse['message'] ?? "Data berhasil disimpan"}");

          // Clear form after successful submission
          clearForm();
          print("🧹 Form cleared");

          // Navigate back
          Get.back();
          print("🔙 Navigated back");
        } else {
          print("❌ API response indicates failure: ${jsonResponse['message']}");
          throw Exception(jsonResponse['message'] ?? 'Unknown error occurred');
        }
      } else {
        print("❌ HTTP request failed with status: ${response.statusCode}");

        // Handle error response
        String errorMessage = 'Gagal menyimpan data';

        if (jsonResponse.containsKey('message')) {
          errorMessage = jsonResponse['message'];
          print("📄 Error message from API: $errorMessage");
        } else if (jsonResponse.containsKey('errors')) {
          print("📋 Validation errors found:");
          var errors = jsonResponse['errors'];
          List<String> errorList = [];

          errors.forEach((key, value) {
            print("  - $key: $value");
            if (value is List) {
              errorList.addAll(value.cast<String>());
            } else {
              errorList.add(value.toString());
            }
          });

          errorMessage = errorList.join('\n');
          print("📝 Combined error message: $errorMessage");
        }

        Get.rawSnackbar(
          message: errorMessage,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 8,
        );

        print("📋 Error message shown: $errorMessage");
      }
    } catch (e) {
      print("💥 Exception occurred during submission: $e");
      print("📍 Exception type: ${e.runtimeType}");

      // Handle network or other errors
      Get.rawSnackbar(
        message: "Terjadi kesalahan: ${e.toString()}",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );

      print("📋 Exception error message shown");
    } finally {
      isLoading.value = false;
      print("🔄 Loading state set to false");
      print("🏁 Report submission process completed");
    }
  }

  void clearForm() {
    print("🧹 Clearing form...");

    String prevAmount = amount.value;
    String prevInformation = information.value;
    File? prevImage = imageFile.value;

    amount.value = "";
    information.value = "";
    imageFile.value = null;
    areaError.value = "";
    informationError.value = "";
    imageError.value = false;

    print("📋 Form cleared:");
    print("  - Area: '$prevAmount' → '${amount.value}'");
    print("  - Information: '$prevInformation' → '${information.value}'");
    print("  - Image: ${prevImage != null ? 'Had image' : 'No image'} → ${imageFile.value != null ? 'Has image' : 'No image'}");
    print("  - All errors reset");
  }

  @override
  void onClose() {
    print("🔧 ReportInputController disposing...");
    super.onClose();
    print("✅ ReportInputController disposed");
  }
}