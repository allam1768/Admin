import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../global component/CustomButton.dart';

class ImageUploadComponent extends StatelessWidget {
  final _image = Rx<File?>(null);
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
    }
  }

  void _showPreview() {
    if (_image.value == null) return;
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
              boundaryMargin: EdgeInsets.all(20),
              minScale: 1,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  _image.value!,
                  width: 300.w,
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
          onTap: () => _image.value != null ? _showPreview() : _pickImage(),
          child: Obx(() => Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: _image.value != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(_image.value!, fit: BoxFit.cover),
            )
                : Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          )),
        ),
        SizedBox(height: 15.h),
        CustomButton(
          text: "Take Photo",
          color: Color(0xFFFFA726),
          onPressed: _pickImage,
          fontSize: 20,
        ),
      ],
    );
  }
}
