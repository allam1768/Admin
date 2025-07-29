import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../data/models/worker_model.dart';
import '../../../../../values/app_color.dart';

class WorkerCard extends StatelessWidget {
  final WorkerModel? worker;
  final String? imagePath;
  final bool isNetworkImage;
  final bool isLoading;

  const WorkerCard({
    super.key,
    this.worker,
    this.imagePath,
    this.isNetworkImage = false,
    this.isLoading = false,
  });

  // Factory constructor untuk membuat skeleton card
  factory WorkerCard.skeleton() {
    return const WorkerCard(
      worker: null,
      imagePath: '',
      isNetworkImage: false,
      isLoading: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: Colors.grey,
        highlightColor: Color(0xFFE0E0E0),
      ),
      child: GestureDetector(
        onTap: isLoading ? null : () {
          if (worker != null) {
            Get.toNamed('/AccountWorker', arguments: worker);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(2, 2),
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
                  border: Border.all(color: Colors.grey, width: 2.w),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: isLoading ? _skeletonImage() : _buildImage(),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoading ? 'Worker Name Placeholder' : (worker?.name ?? ''),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return Icon(
        Icons.person,
        size: 40.r,
        color: Colors.grey[600],
      );
    }

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
              strokeWidth: 2.w,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $error');
          return Icon(
            Icons.person,
            size: 40.r,
            color: Colors.grey[600],
          );
        },
      );
    }

    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading asset image: $error');
        return Icon(
          Icons.person,
          size: 40.r,
          color: Colors.grey[600],
        );
      },
    );
  }

  Widget _skeletonImage() {
    return Container(
      width: 60.r,
      height: 60.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(
        Icons.person,
        size: 40.r,
        color: Colors.white54,
      ),
    );
  }
}