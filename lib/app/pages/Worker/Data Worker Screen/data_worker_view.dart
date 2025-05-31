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
              onBackTap: () {},
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.workers.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data worker'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchWorkers,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.zero,
                      itemCount: controller.workers.length,
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (_, index) {
                        final worker = controller.workers[index];
                        return WorkerCard(
                          nokaryawan: worker.id.toString(),
                          name: worker.name,
                          imagePath: worker.image ?? 'assets/images/example.png',
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
