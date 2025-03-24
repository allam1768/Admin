import 'package:admin/app/pages/Detail%20Data%20Screen/detail_data_controller.dart';
import 'package:admin/app/pages/Detail%20Data%20Screen/widgets/DataCard.dart';
import 'package:admin/app/pages/Detail%20Data%20Screen/widgets/ExpandableHistoryCard.dart';
import 'package:admin/app/pages/Detail%20Data%20Screen/widgets/MonthSlider.dart';
import 'package:admin/app/pages/Detail%20Data%20Screen/widgets/SummaryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../global component/app_bar.dart';

class DetailDataView extends StatefulWidget {
  const DetailDataView({super.key});

  @override
  _DetailDataViewState createState() => _DetailDataViewState();
}

class _DetailDataViewState extends State<DetailDataView> {
  final controller = Get.find<DetailDataController>();
  int selectedMonth = 0;

  @override
  Widget build(BuildContext context) {
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
                        print("Tombol QR diklik!");
                      },
                    ),
                    SizedBox(height: 20.h),

                    // MonthSlider
                    MonthSlider(
                      onMonthChanged: (index) {
                        setState(() {
                          selectedMonth = index;
                        });
                        print("Bulan terpilih: ${selectedMonth + 1}");
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Grafik DataCard
                    DataCard(
                      title: "Land",
                      dataPoints: [
                        {'x': 'Minggu 1', 'y': 10},
                        {'x': 'Minggu 2', 'y': 15},
                        {'x': 'Minggu 3', 'y': 7},
                        {'x': 'Minggu 4', 'y': 12},
                      ],

                        onNoteChanged: (text) {
                        print("Catatan: $text");
                      }, onSave: () {  },
                    ),
                    SizedBox(height: 25.h),

                    DataCard(
                      title: "Fly",
                      dataPoints: [
                        {'x': 'Minggu 1', 'y': 10},
                        {'x': 'Minggu 2', 'y': 15},
                        {'x': 'Minggu 3', 'y': 7},
                        {'x': 'Minggu 4', 'y': 12},
                      ],

                        onNoteChanged: (text) {
                        print("Catatan: $text");
                      }, onSave: () {  },
                    ),
                    SizedBox(height: 35.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 9.w),
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
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
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
