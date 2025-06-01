import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        color: Color(0xFF9BBB9C),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: _buildProfileImage(),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Tambahkan debug print untuk melihat nilai email yang diterima
                Builder(builder: (context) {
                  print('Email in UserInfoCard: "$email"');
                  return Text(
                    email.isNotEmpty ? email : "Email tidak tersedia",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // Jika imagePath kosong atau null
    if (imagePath.isEmpty || imagePath == "assets/images/default_profile.png") {
      return Icon(
        Icons.person,
        size: 40.r,
        color: Colors.grey[600],
      );
    }

    // Jika ini adalah network image (URL)
    if (imagePath.contains("http")) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: Colors.grey[600],
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 40.r,
            color: Colors.grey[600],
          );
        },
      );
    }

    // Jika ini adalah asset image
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.person,
          size: 40.r,
          color: Colors.grey[600],
        );
      },
    );
  }
}