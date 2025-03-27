import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'CustomButton.dart';

class ImageUploadComponent extends StatelessWidget {
  final Rx<File?> imageFile;
  final RxBool imageError;

  ImageUploadComponent({required this.imageFile, required this.imageError});

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      imageError.value = false; // Reset error jika berhasil ambil gambar
    }
  }

  void showPreview() {
    if (imageFile.value == null) return;

    Get.dialog(
      GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 1,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile.value!,
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upload Image", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),

        GestureDetector(
          onTap: () => imageFile.value != null ? showPreview() : pickImage(),
          child: Obx(() => Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: imageError.value ? Colors.red : Colors.grey.shade400, // Border merah jika error
                width: 2,
              ),
            ),
            child: imageFile.value != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(imageFile.value!, fit: BoxFit.cover),
            )
                : Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          )),
        ),

        Obx(() => imageError.value
            ? Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Text(
            "Image harus diisi!",
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
        )
            : SizedBox()),

        SizedBox(height: 10.h),

        CustomButton(
          text: "Take Photo",
          color: const Color(0xFFFFA726),
          onPressed: pickImage,
          fontSize: 20.sp,
        ),
      ],
    );
  }
}
