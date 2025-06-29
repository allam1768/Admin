import 'package:admin/values/app_color.dart';
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
        color: AppColor.backgroundsetengah,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          _buildCircleAvatar(),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  email,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar() {
    // Debug print
    print('InfoCard - Image path: "$imagePath"');
    print('InfoCard - Is HTTP: ${imagePath.startsWith("http")}');

    return CircleAvatar(
      radius: 30.r,
      backgroundColor: Colors.white,
      backgroundImage: _getImageProvider(),
      onBackgroundImageError: (exception, stackTrace) {
        print('InfoCard - Image loading error: $exception');
      },
      child: imagePath.isEmpty || _shouldShowFallback()
          ? Icon(
        Icons.person,
        size: 30.r,
        color: Colors.grey[600],
      )
          : null,
    );
  }

  ImageProvider? _getImageProvider() {
    if (imagePath.isEmpty) {
      return null;
    }

    if (imagePath.contains("http")) {
      return NetworkImage(imagePath);
    }

    return AssetImage(imagePath);
  }

  bool _shouldShowFallback() {
    return imagePath.isEmpty || imagePath == "assets/images/example.png";
  }
}