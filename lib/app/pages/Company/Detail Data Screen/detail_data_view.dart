import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/DataCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/ExpandableHistoryCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/MonthSlider.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/SummarySection.dart';
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
                      onQrTap: () => Get.toNamed('/CreateQrTools'),
                    ),
                    SizedBox(height: 20.h),

                    MonthSlider(onMonthChanged: controller.changeMonth),
                    SizedBox(height: 20.h),

                    DataCard(
                      title: "Land",
                      chartData: controller.getChartData("Land"),
                      onNoteChanged: (text) => controller.updateNote(0, text),
                      onSave: () => print("Data Land disimpan!"),
                    ),
                    SizedBox(height: 25.h),

                    DataCard(
                      title: "Fly",
                      chartData: controller.getChartData("Fly"),
                      onNoteChanged: (text) => controller.updateNote(1, text),
                      onSave: () => print("Data Fly disimpan!"),
                    ),
                    SizedBox(height: 35.h),

                    Row(
                      children: [
                        Text(
                          "History",
                          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 9.w),
                        SvgPicture.asset("assets/icons/history_icon.svg", width: 36.w, height: 36.h),
                      ],
                    ),
                    SizedBox(height: 25.h),

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
