import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent extends StatelessWidget {
  final Rx<File?> profileImage;

  ImagePickerComponent({required this.profileImage});

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Ambil dari Kamera'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () => _showImageSourceDialog(context),
          child: Obx(
                () => Container(
              width: 150.r,
              height: 150.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[500],
              ),
              child: Center(
                child: profileImage.value != null
                    ? ClipOval(
                  child: Image.file(
                    profileImage.value!,
                    width: 120.r,
                    height: 120.r,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.image, size: 40.r, color: Colors.black),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(context),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: Colors.orange, size: 24.r),
            ),
          ),
        ),
      ],
    );
  }
}
