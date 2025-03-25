import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/DataCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/ExpandableHistoryCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/MonthSlider.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/SummarySection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../global component/app_bar.dart';
import 'detail_data_controller.dart';

class DetailDataView extends StatelessWidget {
  const DetailDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailDataController>();

    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Detail Data"),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SummarySection(
                      totalAlat: 6,
                      totalPengecekan: 4,
                      onQrTap: () {
                        Get.toNamed('/CreateQrTools');
                      },
                    ),
                    SizedBox(height: 20.h),

                    // MonthSlider
                    MonthSlider(
                      onMonthChanged: (index) {
                        controller.selectedMonth.value = index;
                        print("Bulan terpilih: ${index + 1}");
                      },
                    ),

                    SizedBox(height: 20.h),

                    // DataCard untuk Land
                    DataCard(
                      title: "Land",
                      chartData: [
                        FlSpot(1, 10),
                        FlSpot(2, 15),
                        FlSpot(3, 7),
                        FlSpot(4, 12),
                      ],
                      onNoteChanged: (text) => print("Catatan: $text"),
                      onSave: () => print("Data disimpan!"),
                    ),
                    SizedBox(height: 25.h),

                    // DataCard untuk Fly
                    DataCard(
                      title: "Fly",
                      chartData: [
                        FlSpot(1, 10),
                        FlSpot(2, 15),
                        FlSpot(3, 7),
                        FlSpot(4, 12),
                      ],
                      onNoteChanged: (text) => print("Catatan: $text"),
                      onSave: () => print("Data disimpan!"),
                    ),
                    SizedBox(height: 35.h),

                    Row(
                      children: [
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 9.w),
                        SvgPicture.asset(
                          "assets/icons/history_icon.svg",
                          width: 36.w,
                          height: 36.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),

                    // ListView di dalam ScrollView
                    Obx(() => ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.traps.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, index) {
                        final item = controller.traps[index];
                        return ExpandableHistoryCard(
                          imagePath: item["image"],
                          location: item["location"],
                          historyItems: List<Map<String, dynamic>>.from(item["history"]),
                          isExpanded: item["isExpanded"],
                          onTap: () => controller.toggleExpand(index),
                        );
                      },
                    )),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
