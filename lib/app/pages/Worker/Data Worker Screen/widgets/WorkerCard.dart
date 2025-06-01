import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../data/models/worker_model.dart';
import '../../../../../values/app_color.dart';

class WorkerCard extends StatelessWidget {
  final WorkerModel worker; // Ganti dengan model worker lengkap
  final String? imagePath;
  final bool isNetworkImage;

  const WorkerCard({
    super.key,
    required this.worker,
    this.imagePath,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Kirim data worker ke halaman AccountWorker
        Get.toNamed('/AccountWorker', arguments: worker);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColor.ijomuda.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.r,
              height: 60.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF275637), width: 2),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: _buildImage(),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Tambahan: Tampilkan phone number jika ada
                  if (worker.phoneNumber != null && worker.phoneNumber!.isNotEmpty)
                    Text(
                      'Phone: ${worker.phoneNumber}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black45,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Jika tidak ada imagePath atau imagePath kosong
    if (imagePath == null || imagePath!.isEmpty) {
      return Icon(
        Icons.person,
        size: 40.r,
        color: Colors.grey[600],
      );
    }

    // Jika ini adalah network image (dari server)
    if (isNetworkImage) {
      return Image.network(
        imagePath!,
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
      imagePath!,
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