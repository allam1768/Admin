import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../values/config.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;

  const UserInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColor.backgroundsetengah,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          _buildProfileImage(),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // Debug: Print imagePath untuk debugging
    print('👤 User Image Path: $imagePath');

    // Jika imagePath kosong atau null, gunakan default avatar
    if (imagePath.isEmpty) {
      return CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.grey.shade300,
        child: Icon(
          Icons.person,
          size: 30.sp,
          color: Colors.grey.shade600,
        ),
      );
    }

    // Jika sudah berupa URL HTTP/HTTPS (dari network)
    if (imagePath.startsWith('http')) {
      final fullImageUrl = Config.getImageUrl(imagePath);
      print('🌐 Full Network Image URL: $fullImageUrl');

      return CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.grey.shade300,
        child: ClipOval(
          child: Image.network(
            fullImageUrl,
            width: 60.r,
            height: 60.r,
            fit: BoxFit.cover,
            headers: Config.commonHeaders,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.blue,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('❌ User Image load error: $error');
              return Icon(
                Icons.person,
                size: 30.sp,
                color: Colors.grey.shade600,
              );
            },
          ),
        ),
      );
    }

    // Jika path relatif (dari storage)
    if (!imagePath.startsWith('assets/')) {
      final fullImageUrl = Config.getImageUrl(imagePath);
      print('📁 Full Storage Image URL: $fullImageUrl');

      return CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.grey.shade300,
        child: ClipOval(
          child: Image.network(
            fullImageUrl,
            width: 60.r,
            height: 60.r,
            fit: BoxFit.cover,
            headers: Config.commonHeaders,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.blue,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('❌ User Image load error: $error');
              return Icon(
                Icons.person,
                size: 30.sp,
                color: Colors.grey.shade600,
              );
            },
          ),
        ),
      );
    }

    // Jika path berupa asset lokal
    print('📱 Local Asset Image: $imagePath');
    return CircleAvatar(
      radius: 30.r,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(imagePath),
      onBackgroundImageError: (exception, stackTrace) {
        print('❌ Asset Image load error: $exception');
      },
    );
  }
}