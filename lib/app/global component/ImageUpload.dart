import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../values/config.dart'; // Import Config class

class ImageUpload extends StatelessWidget {
  final Rx<File?> imageFile;
  final RxBool? imageError;
  final String title;
  final bool showButton;
  final String? imageUrl;

  const ImageUpload({
    Key? key,
    required this.imageFile,
    this.imageError,
    this.title = "Upload Image",
    this.showButton = true,
    this.imageUrl,
  }) : super(key: key);

  Future<void> pickImage() async {
    final picker = ImagePicker();

    await Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pilih Gambar",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickButton(Icons.camera_alt, "Camera", () async {
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    imageFile.value = File(pickedFile.path);
                    imageError?.value = false;
                    Get.back();
                  }
                }),
                _buildPickButton(Icons.image, "Gallery", () async {
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    imageFile.value = File(pickedFile.path);
                    imageError?.value = false;
                    Get.back();
                  }
                }),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPickButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: Colors.grey.shade200,
              child: Icon(icon, size: 28.sp, color: Colors.black54),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPreview() {
    if (imageFile.value == null && imageUrl == null) return;

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
              boundaryMargin: EdgeInsets.all(20.w),
              minScale: 1,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: imageFile.value != null
                    ? Image.file(
                  imageFile.value!,
                  width: 300.w,
                  fit: BoxFit.contain,
                )
                    : Image.network(
                  Config.getImageUrl(imageUrl),
                  width: 300.w,
                  fit: BoxFit.contain,
                  headers: Config.commonHeaders,
                ),
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
    );
  }

  // Helper method untuk mendapatkan URL gambar yang benar
  String _getImageUrl() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return '';
    }

    // Debug print untuk melihat URL yang digunakan
    final finalUrl = Config.getImageUrl(imageUrl);
    print('Original imageUrl: $imageUrl');
    print('Final URL: $finalUrl');

    return finalUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => pickImage(),
          child: Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: imageError?.value == true
                    ? Colors.red
                    : Colors.grey.shade300,
                width: 2.w,
              ),
            ),
            child: Obx(() {
              // Prioritas: File lokal > Network image > Placeholder
              if (imageFile.value != null) {
                // Tampilkan gambar dari file lokal
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.file(
                        imageFile.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: showPreview,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (imageUrl != null && imageUrl!.isNotEmpty) {
                // Tampilkan gambar dari network
                final networkUrl = _getImageUrl();

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        networkUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        headers: Config.commonHeaders,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  strokeWidth: 3.w,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Debug print untuk error
                          print('Image loading error: $error');
                          print('URL: $networkUrl');

                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48.sp,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Gambar tidak tersedia',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'URL: $networkUrl',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: showPreview,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Placeholder ketika tidak ada gambar
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 64.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Tap untuk upload gambar',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
        if (imageError != null)
          Obx(() => imageError!.value
              ? Padding(
            padding: EdgeInsets.only(top: 8.h, left: 4.w),
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Gambar harus diisi',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : const SizedBox()),
      ],
    );
  }
}