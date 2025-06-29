import 'package:admin/values/app_color.dart';
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
      backgroundColor: AppColor.background,
      body: Obx(
            () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(controller.currentIndex.value),
            child: controller.screens[controller.currentIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10.h,
          top: 10.h,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.r,
                spreadRadius: 0,
                offset: Offset(0, 8.h),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8.r,
                spreadRadius: 0,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(controller.icons.length, (index) {
              return Obx(() {
                final isActive = controller.isActive(index);
                return GestureDetector(
                  onTap: () => controller.changeTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    height: 56.h,
                    width: 56.w,
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? LinearGradient(
                        colors: [
                          AppColor.oren.withOpacity(0.9),
                          AppColor.oren,
                          AppColor.oren.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.5, 1.0],
                      )
                          : null,
                      color: isActive ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: AppColor.oren.withOpacity(0.35),
                          blurRadius: 12.r,
                          spreadRadius: 0,
                          offset: Offset(0, 6.h),
                        ),
                        BoxShadow(
                          color: AppColor.oren.withOpacity(0.2),
                          blurRadius: 6.r,
                          spreadRadius: 0,
                          offset: Offset(0, 2.h),
                        ),
                      ]
                          : null,
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) => ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        ),
                        child: Transform.scale(
                          scale: isActive ? 1.0 : 0.9,
                          child: SvgPicture.asset(
                            controller.icons[index],
                            key: ValueKey<bool>(isActive),
                            colorFilter: ColorFilter.mode(
                              isActive ? Colors.white : Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                            width: isActive ? 26.w : 24.w,
                            height: isActive ? 26.h : 24.h,
                          ),
                        ),
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