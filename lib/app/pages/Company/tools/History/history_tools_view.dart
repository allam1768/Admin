import 'package:admin/app/pages/Company/tools/History/widgets/GroupHistoryCard.dart';
import 'package:admin/app/pages/Company/tools/History/widgets/SingleHistoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../../../../global component/CustomAppBar.dart';
import 'history_tools_controller.dart';

class HistoryToolView extends StatelessWidget {
  final controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => CustomAppBar(
          title: controller.getDisplayTitle(),
      onBackTap: () {
        Get.back(); // Kembali ke halaman sebelumnya
      },
    )),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColor.ijomuda,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Loading data...",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => controller.refreshData(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.ijomuda,
                          ),
                          child: Text(
                            "Retry",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredHistoryData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          controller.isFiltered
                              ? "No history found for this tool"
                              : "No history data available",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group by month when showing filtered data
                var groupedHistory = controller.groupByMonth();
                var sortedKeys = groupedHistory.keys.toList()
                  ..sort((a, b) {
                    // Sort by year.month in descending order (newest first)
                    List<String> aParts = a.split('.');
                    List<String> bParts = b.split('.');
                    int aYear = int.parse(aParts[1]);
                    int aMonth = int.parse(aParts[0]);
                    int bYear = int.parse(bParts[1]);
                    int bMonth = int.parse(bParts[0]);

                    if (aYear != bYear) {
                      return bYear.compareTo(aYear);
                    }
                    return bMonth.compareTo(aMonth);
                  });

                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  color: AppColor.ijomuda,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    children: sortedKeys.map((monthKey) {
                      var items = groupedHistory[monthKey]!;

                      // Sort items by date (newest first)
                      items.sort((a, b) {
                        DateTime dateA = _parseDate(a["date"]);
                        DateTime dateB = _parseDate(b["date"]);
                        return dateB.compareTo(dateA);
                      });

                      return (items.length >= 4)
                          ? GroupedHistoryCard(
                        month: monthKey,
                        items: items,
                        isToolGroup: false, // This is month grouping
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month header for single items
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: AppColor.ijomuda.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              "${controller.getMonthName(monthKey)} ${monthKey.split('.')[1]}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.ijomuda,
                              ),
                            ),
                          ),
                          ...items.map((item) => SingleHistoryCard(item: item)).toList(),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseDate(String dateString) {
    try {
      List<String> parts = dateString.split('.');
      return DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    } catch (e) {
      return DateTime.now();
    }
  }
}