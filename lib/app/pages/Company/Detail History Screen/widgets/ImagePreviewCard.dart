import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ImagePreviewCard extends StatelessWidget {
  final String imageUrl;
  final String imageTitle;
  final bool isLoading;

  const ImagePreviewCard({
    Key? key,
    required this.imageUrl,
    required this.imageTitle,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          _showImagePreview(context, imageUrl);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          width: double.infinity,
          height: 0.25.sh,
          color: Colors.grey[300],
          child: isLoading
              ? _buildShimmerPlaceholder()
              : _buildImageWithShimmer(imageUrl),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.grey[300]),
    );
  }

  Widget _buildImageWithShimmer(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildShimmerPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.broken_image,
              size: 64.sp,
              color: Colors.grey[700],
            ),
          );
        },
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
      );
    }
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.r),
          child: imageUrl.startsWith('http')
              ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 64.sp,
                    color: Colors.grey[700],
                  ),
                ),
              );
            },
          )
              : Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
