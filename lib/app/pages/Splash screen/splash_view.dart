import 'package:admin/app/pages/Splash%20screen/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../values/app_color.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          Center(
            child: Obx(() => AnimatedScale(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutBack,
              scale: controller.scale.value,
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                width: MediaQuery.of(context).size.width *
                    0.3, // 30% dari lebar layar
              ),
            )),
          ),
          Positioned(
            bottom: 20,
            left: 100,
            right: 100,
            child: Obx(
                  () => controller.showLoading.value
                  ? LinearProgressIndicator(
                backgroundColor: AppColor.background,
                valueColor:
                AlwaysStoppedAnimation<Color>(AppColor.btnoren),
              )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
