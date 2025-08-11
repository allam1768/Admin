import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../values/config.dart';

class CompanyCard extends StatelessWidget {
  final int id;
  final String companyName;
  final String companyAddress;
  final String phoneNumber;
  final String email;
  final String? imagePath;
  final String createdAt;
  final String updatedAt;
  final String companyQr;
  final VoidCallback? onMoreTap;
  final bool isLoading;

  const CompanyCard({
    Key? key,
    required this.id,
    required this.companyName,
    required this.companyAddress,
    required this.phoneNumber,
    required this.email,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.companyQr,
    this.onMoreTap,
    this.isLoading = false,
  }) : super(key: key);

  // Factory constructor untuk membuat skeleton card
  factory CompanyCard.skeleton() {
    return CompanyCard(
      id: 0,
      companyName: 'Company Name Placeholder',
      companyAddress: 'Company Address Placeholder Text',
      phoneNumber: '+1234567890',
      email: 'email@example.com',
      imagePath: '',
      createdAt: '2024-01-01',
      updatedAt: '2024-01-01',
      companyQr: '',
      isLoading: true,
    );
  }

  // Method untuk membuat URL gambar lengkap menggunakan Config
  String _getFullImageUrl(String? imagePath) {
    return Config.getImageUrl(imagePath);
  }

  // Method untuk menyimpan company ID ke SharedPreferences
  Future<void> _saveCompanyId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('companyid', id);
      print('✅ Company ID $id saved to SharedPreferences as int');

      // Debug: Verifikasi penyimpanan
      final savedId = prefs.getInt('companyid');
      print('🔍 Verification - Saved Company ID: $savedId');
    } catch (e) {
      print('❌ Error saving company ID: $e');
    }
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
        onTap: isLoading ? null : () async {
          await _saveCompanyId();

          Get.toNamed('/detaildata', arguments: {
            'id': id,
            'name': companyName,
            'address': companyAddress,
            'phoneNumber': phoneNumber,
            'email': email,
            'imagePath': imagePath ?? '',
            'createdAt': createdAt,
            'updatedAt': updatedAt,
            'companyQr': companyQr,
          });
        },
        child: Container(
          padding: EdgeInsets.all(10.w),
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
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: isLoading
                    ? _skeletonImage()
                    : _buildImageWidget(),
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          companyAddress,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: isLoading ? null : () async {
                      await _saveCompanyId();

                      Get.toNamed('/detailcompany', arguments: {
                        'id': id,
                        'name': companyName,
                        'address': companyAddress,
                        'phoneNumber': phoneNumber,
                        'email': email,
                        'imagePath': imagePath ?? '',
                        'createdAt': createdAt,
                        'updatedAt': updatedAt,
                        'companyQr': companyQr,
                      });
                    },
                    child: Icon(Icons.more_vert, size: 18.sp, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    final fullImageUrl = _getFullImageUrl(imagePath);

    // Debug: Print URL untuk melihat apakah URL sudah benar
    print('🖼️ Image URL: $fullImageUrl');

    // Jika URL menunjuk ke assets (default image), tampilkan fallback
    if (fullImageUrl.startsWith('assets/')) {
      return _fallbackImage();
    }

    return Image.network(
      fullImageUrl,
      width: double.infinity,
      height: 180.h,
      fit: BoxFit.cover,
      headers: Config.commonHeaders, // Menggunakan headers dari config
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: double.infinity,
          height: 180.h,
          color: Colors.grey.shade300,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2.0,
              color: Colors.blue,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Debug: Print error untuk debugging
        print('❌ Image load error: $error');
        print('🔗 Failed URL: $fullImageUrl');
        return _fallbackImage();
      },
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 180.h,
      color: Colors.grey.shade400,
      child: Icon(Icons.business, size: 36.sp, color: Colors.white),
    );
  }

  Widget _skeletonImage() {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}