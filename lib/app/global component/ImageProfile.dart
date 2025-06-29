import 'dart:io';
import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageProfile extends StatelessWidget {
  final Rx<File?> profileImage;
  final String? imageUrl;
  final Function(ImageSource)? onImagePicked;

  const ImageProfile({
    super.key,
    required this.profileImage,
    this.imageUrl,
    this.onImagePicked,
  });

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);

        // Call the callback if provided
        if (onImagePicked != null) {
          onImagePicked!(source);
        }

        // Show success message
        Get.snackbar(
          'Success',
          source == ImageSource.camera
              ? 'Foto berhasil diambil'
              : 'Gambar berhasil dipilih',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        source == ImageSource.camera
            ? 'Gagal mengambil foto: ${e.toString()}'
            : 'Gagal memilih gambar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Sumber Gambar',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColor.oren, size: 24.sp),
              title: Text('Ambil dari Kamera', style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: AppColor.oren, size: 24.sp),
              title: Text('Pilih dari Galeri', style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            // Add option to remove image if there's an existing one
            if (profileImage.value != null || (imageUrl != null && imageUrl!.isNotEmpty))
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red, size: 24.sp),
                title: Text('Hapus Gambar', style: TextStyle(fontSize: 16.sp)),
                onTap: () {
                  Navigator.pop(context);
                  profileImage.value = null;
                  Get.snackbar(
                    'Info',
                    'Gambar telah dihapus',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                    duration: Duration(seconds: 2),
                  );
                },
              ),
            SizedBox(height: 10.h),
          ],
        ),
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
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[500]!, width: 3.w),
                // Add shadow for better visual
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2.r,
                    blurRadius: 5.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Center(
                child: _buildProfileImage(),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2.h,
          right: 8.w,
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(context),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.oren, width: 2.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1.r,
                    blurRadius: 3.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Icon(Icons.camera_alt, color: AppColor.oren, size: 24.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (profileImage.value != null) {
      return ClipOval(
        child: Image.file(
          profileImage.value!,
          width: 120.r,
          height: 120.r,
          fit: BoxFit.cover,
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: 120.r,
          height: 120.r,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColor.oren,
                strokeWidth: 2.w,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading network image: $error');
            return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
          },
        ),
      );
    }

    return Icon(
      Icons.person,
      size: 60.r,
      color: Colors.grey[400],
    );
  }
}