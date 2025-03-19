import 'package:admin/app/pages/Data%20Client%20Screen/widgets/ClientCard.dart';
import 'package:admin/app/pages/Data%20Worker%20Screen/widgets/WorkerCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../global component/app_bar.dart';
import 'data_worker_controller.dart';

class DataWorkerView extends StatelessWidget {
  const DataWorkerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataWorkerController());

    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Worker",
              rightIcon: "assets/icons/add_worker_btn.svg",
              rightOnTap: () {
                Get.offNamed('/add-client');
              },
              showBackButton: false,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(() => ListView.separated(
                  itemCount: controller.worker.length,
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
                  itemBuilder: (context, index) {
                    return WorkerCard(
                      nokaryawan: controller.worker[index]["nokaryawan"]!,
                      name: controller.worker[index]["nama"]!,
                      imagePath: controller.worker[index]["imagePath"]!,
                    );
                  },
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
