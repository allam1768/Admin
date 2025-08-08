import 'package:admin/app/pages/Company/Report/History%20Report%20Screen/widgets/report_admin.dart';
import 'package:admin/app/pages/Company/Report/History%20Report%20Screen/widgets/report_client.dart';
import 'package:admin/app/pages/Company/Report/History%20Report%20Screen/widgets/report_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../data/models/report_model.dart';
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

    Widget buildReportWidget(ReportModel report) {
      switch (report.role) {
        case "worker":
          return ReportWorker(
            name: report.namaPengirim,
            date: report.formattedDate,
            time: report.formattedTime,
            area: report.area,
            informasi: report.informasi,
            reportId: report.id,
          );
        case "client":
          return ReportClient(
            name: report.namaPengirim,
            date: report.formattedDate,
            time: report.formattedTime,
            area: report.area,
            informasi: report.informasi,
            reportId: report.id,
          );
        case "admin":
          return ReportAdmin(
            name: report.namaPengirim,
            date: report.formattedDate,
            time: report.formattedTime,
            area: report.area,
            informasi: report.informasi,
            reportId: report.id,
          );
        default:
          return ReportAdmin(
            name: report.namaPengirim,
            date: report.formattedDate,
            time: report.formattedTime,
            area: report.area,
            informasi: report.informasi,
            reportId: report.id,
          );
      }
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Report",
              showBackButton: true,
              rightIcon: "assets/icons/add_btn.svg",
              rightOnTap: () => Get.offNamed('ReportInput'),
              onBackTap: () => Get.back(),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() {
                  // Loading state
                  if (controller.isLoading.value && controller.reports.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Error state
                  if (controller.hasError.value && controller.reports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Failed to load reports",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: controller.retryLoadReports,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty state
                  if (controller.reports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 60.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "No reports found",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Pull down to refresh",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Reports list with pull to refresh and pagination
                  return RefreshIndicator(
                    onRefresh: controller.refreshReports,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                            !controller.isLoadingMore.value &&
                            controller.currentPage.value < controller.lastPage.value) {
                          controller.loadMoreReports();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        itemCount: controller.groupedReports.length +
                            (controller.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Loading more indicator
                          if (index == controller.groupedReports.length) {
                            return Padding(
                              padding: EdgeInsets.all(16.h),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final groupedReports = controller.groupedReports;
                          final dateKeys = groupedReports.keys.toList();
                          final dateKey = dateKeys[index];
                          final reportsForDate = groupedReports[dateKey]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDateHeader(dateKey),
                              ...reportsForDate.map((report) => Column(
                                children: [
                                  buildReportWidget(report),
                                  SizedBox(height: 12.h),
                                ],
                              )).toList(),
                              SizedBox(height: 8.h),
                            ],
                          );
                        },
                      ),
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