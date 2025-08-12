import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../detail_data_controller.dart';

class ClientInfoSection extends StatelessWidget {
  const ClientInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailDataController>();

    return Obx(() => Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),

      ),
      child: Row(
        children: [
          // Client Profile Picture with loading and error handling
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.btnoren.withOpacity(0.1),
                  AppColor.btnoren.withOpacity(0.3),
                ],
              ),
              border: Border.all(
                color: AppColor.btnoren.withOpacity(0.4),
                width: 2.5,
              ),
            ),
            child: ClipOval(
              child: controller.clientImagePath.value.isNotEmpty
                  ? Image.network(
                controller.getClientImageUrl(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade100,
                    child: Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.btnoren),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : _buildDefaultAvatar(),
            ),
          ),
          SizedBox(width: 16.w),

          // Client Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client label with icon


                // Client name
                Text(
                  controller.clientName.value.isNotEmpty
                      ? controller.clientName.value
                      : 'No Client Assigned',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Client email if available
                if (controller.clientEmail.value.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 12.w,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          controller.clientEmail.value,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

                // Client phone if available
                if (controller.clientPhoneNumber.value.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 12.w,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        controller.clientPhoneNumber.value,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
        ),
      ),
      child: Icon(
        Icons.person_outline,
        size: 28.w,
        color: Colors.grey.shade500,
      ),
    );
  }
}