import 'package:admin/app/pages/Splash%20screen/splash_controller.dart';
import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Obx(() => AnimatedScale(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          scale: controller.scale.value,
          child: SvgPicture.asset(
            'assets/icons/logo.svg',
            width: 120.w,
          ),
        )),
      ),
    );
  }
}
