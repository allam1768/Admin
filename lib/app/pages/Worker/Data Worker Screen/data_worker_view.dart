import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
              child: Obx(() {
                // Loading state dengan skeleton
                if (controller.isLoading.value) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    itemCount: 3, // Tampilkan 3 skeleton cards
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemBuilder: (_, __) => WorkerCard.skeleton(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchWorkers,
                  child: controller.workers.isEmpty
                      ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 0.7.sh, // Using ScreenUtil for screen height
                        child: Center(
                          child: Text(
                            "Belum ada data worker.",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  )
                      : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    itemCount: controller.workers.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemBuilder: (_, index) {
                      final worker = controller.workers[index];

                      String? imageUrl;
                      bool isNetworkImage = false;

                      if (worker.image != null && worker.image!.isNotEmpty) {
                        if (worker.image!.startsWith('http')) {
                          imageUrl = worker.image;
                          isNetworkImage = true;
                        } else {
                          imageUrl = 'https://hamatech.rplrus.com/storage/${worker.image}';
                          isNetworkImage = true;
                        }
                      }

                      return WorkerCard(
                        worker: worker,
                        imagePath: imageUrl,
                        isNetworkImage: isNetworkImage,
                        isLoading: false, // Data sudah dimuat
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}