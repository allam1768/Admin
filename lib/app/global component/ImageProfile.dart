import 'dart:io';
import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageProfile extends StatelessWidget {
  final Rx<File?> profileImage;
  final String? imageUrl; // URL gambar dari server

  const ImageProfile({
    super.key, 
    required this.profileImage, 
    this.imageUrl,
  });

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70, // Kompresi kualitas gambar untuk mengurangi ukuran
    );
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
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[500]!, width: 3),
              ),
              child: Center(
                child: _buildProfileImage(),
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
              child: Icon(Icons.camera_alt, color: AppColor.oren, size: 24.r),
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper method untuk menampilkan gambar profil
  Widget _buildProfileImage() {
    // Jika ada file gambar yang dipilih, tampilkan itu
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
    
    // Jika tidak ada file tapi ada URL gambar, tampilkan dari URL
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
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
          },
        ),
      );
    }
    
    // Jika tidak ada keduanya, tampilkan ikon default
    return Icon(Icons.person, size: 40.r, color: Colors.black);
  }
}
