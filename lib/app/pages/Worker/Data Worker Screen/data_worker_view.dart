import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import 'data_worker_controller.dart';
import 'widgets/WorkerCard.dart';

class DataWorkerView extends StatelessWidget {
  const DataWorkerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataWorkerController());

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Worker",
              rightIcon: "assets/icons/add_worker_btn.svg",
              rightOnTap: controller.goToCreateAccountWorker,
              showBackButton: false,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(() => ListView.separated(
                  itemCount: controller.worker.length,
                  separatorBuilder: (_, __) => SizedBox(height: 20.h),
                  itemBuilder: (_, index) => WorkerCard(
                    nokaryawan: controller.worker[index]["nokaryawan"]!,
                    name: controller.worker[index]["nama"]!,
                    imagePath: controller.worker[index]["imagePath"]!,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
