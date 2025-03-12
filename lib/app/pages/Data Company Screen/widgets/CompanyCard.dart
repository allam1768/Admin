import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyCard extends StatelessWidget {
  final String companyName;
  final String imagePath;
  final VoidCallback onTap; // Callback saat card ditekan

  const CompanyCard({
    Key? key,
    required this.companyName,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Menjalankan aksi saat card ditekan
      child: Container(
        width: 342.w,
        height: 168.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF6E6E6E), width: 1.w), // Border tipis
        ),
        child: Stack(
          children: [
            // Gambar latar belakang
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                imagePath,
                width: 342.w,
                height: 168.h,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient overlay untuk teks
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  companyName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Warna teks putih biar kontras
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
