import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'bottomnav_controller.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: Obx(() => controller.screens[controller.currentIndex.value]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 35.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFA3B8A3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(controller.icons.length, (index) {
              return Obx(() {
                return GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: Container(
                    height: 50.r,
                    width: 50.r,
                    decoration: BoxDecoration(
                      color: controller.isActive(index)
                          ? const Color(0xFFFFA726)
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        controller.icons[index],
                        color: controller.isActive(index)
                            ? Colors.black
                            : Colors.grey,
                        width: 15.w,
                      ),
                    ),
                  ),
                );
              });
            }),
          ),
        ),
      ),
    );
  }
}
