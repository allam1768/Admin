import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CompanyCard extends StatelessWidget {
  final int id; // Tambahkan ID
  final String companyName;
  final String companyAddress;
  final String phoneNumber; // Tambahkan phone number
  final String email; // Tambahkan email
  final String? imagePath;
  final String createdAt; // Tambahkan created at
  final String updatedAt; // Tambahkan updated at
  final VoidCallback? onMoreTap;

  const CompanyCard({
    Key? key,
    required this.id, // Required ID
    required this.companyName,
    required this.companyAddress,
    required this.phoneNumber, // Required phone number
    required this.email, // Required email
    this.imagePath,
    required this.createdAt, // Required created at
    required this.updatedAt, // Required updated at
    this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate ke halaman detail company dengan semua data
        Get.toNamed('/detaildata', arguments: {
          'id': id,
          'name': companyName,
          'address': companyAddress,
          'phoneNumber': phoneNumber,
          'email': email,
          'imagePath': imagePath ?? '',
          'createdAt': createdAt,
          'updatedAt': updatedAt,
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
            // Gambar dengan tinggi 180.h
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: imagePath != null && imagePath!.isNotEmpty
                  ? Image.network(
                imagePath!,
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
                headers: {
                  'ngrok-skip-browser-warning': '1',
                },
                errorBuilder: (_, __, ___) => _fallbackImage(),
              )
                  : _fallbackImage(),
            ),
            SizedBox(height: 10.h),

            // Nama + alamat + titik tiga
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
                  onTap: () {
                    // Navigate ke halaman detail saat titik tiga ditekan
                    Get.toNamed('/detailcompany', arguments: {
                      'id': id,
                      'name': companyName,
                      'address': companyAddress,
                      'phoneNumber': phoneNumber,
                      'email': email,
                      'imagePath': imagePath ?? '',
                      'createdAt': createdAt,
                      'updatedAt': updatedAt,
                    });
                  },
                  child: Icon(Icons.more_vert, size: 18.sp, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
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
}