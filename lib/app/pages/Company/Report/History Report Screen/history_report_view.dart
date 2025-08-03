import 'package:admin/app/pages/Company/Report/History%20Report%20Screen/widgets/report_client.dart';
import 'package:admin/app/pages/Company/Report/History%20Report%20Screen/widgets/report_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../../../../global component/CustomAppBar.dart';
import 'history_report_controller.dart';

class HistoryReportView extends StatelessWidget {
  HistoryReportView({Key? key}) : super(key: key);

  final HistoryReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget buildDateHeader(String date) {
      return Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Report",
              showBackButton: false,
              rightIcon: "assets/icons/add_btn.svg",
              rightOnTap: () => Get.toNamed('ReportInput'),onBackTap: () => Get.back(),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() {
                  if (controller.reports.isEmpty) {
                    return Center(
                      child: Text(
                        "Belum ada data",
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    itemCount: controller.reports.length,
                    itemBuilder: (context, index) {
                      final report = controller.reports[index];
                      final isWorker = report["role"] == "worker";
                      final reportDate = report["date"] ?? '';

                      Widget dateHeader = const SizedBox();
                      if (index == 0 ||
                          reportDate != controller.reports[index - 1]["date"]) {
                        dateHeader = buildDateHeader(reportDate);
                      }

                      Widget reportWidget = isWorker
                          ? ReportWorker(
                              name: report["name"] ?? '',
                              date: reportDate,
                              time: report["time"] ?? '',
                            )
                          : ReportClient(
                              name: report["name"] ?? '',
                              date: reportDate,
                              time: report["time"] ?? '',
                            );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          dateHeader,
                          reportWidget,
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
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
