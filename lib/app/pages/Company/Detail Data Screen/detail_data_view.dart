import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/ChartTool.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/DataCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/ToolCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/DateSelection.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/SummarySection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import 'detail_data_controller.dart';

class DetailDataView extends StatelessWidget {
  const DetailDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailDataController>();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Detail Data",
              onBackTap: controller.goToDashboard,
              rightIcon: "assets/icons/report.svg",
              rightOnTap: () => Get.toNamed('/HistoryReport'),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchData,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Info Section
                      Obx(() => SummarySection(
                        totalAlat: controller.traps.length,
                        totalPengecekan: controller.totalPengecekan,
                        onQrTap: () => Get.offNamed('/CreateQrTools', arguments: {
                          'companyId': controller.companyId.value,
                        }),
                      )),
                      SizedBox(height: 20.h),

                      // Month Selection with callback
                      MonthSelection(
                        onMonthRangeChanged: controller.onDateRangeChanged,
                      ),
                      SizedBox(height: 20.h),

                      // Dynamic Chart Cards based on Pest Types
                      Obx(() {
                        if (controller.isLoadingChart.value) {
                          return Container(
                            height: 300.h,
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.btnoren),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Loading chart data...',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (controller.availablePestTypes.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(32.w),
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  size: 64.w,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "No chart data available",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Data will appear when catches are recorded for tools",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        // Generate layered charts for each pest type
                        return Column(
                          children: controller.availablePestTypes.map((pestType) {
                            // Get layered data for this pest type
                            List<List<FlSpot>> layeredChartData = controller.getLayeredChartDataByPestType(pestType);
                            List<Color> layeredColors = controller.getLayeredColorsByPestType(pestType);
                            List<String> labels = controller.getLabelsByPestType(pestType);

                            return Column(
                              children: [
                                ChartTool(
                                  title: pestType,
                                  chartData: layeredChartData,
                                  colors: layeredColors,
                                  labels: labels,
                                  onNoteChanged: (text) => controller.updateNote(
                                      controller.availablePestTypes.indexOf(pestType),
                                      text
                                  ),
                                  onSave: () => print("Layered data for $pestType saved!"),
                                ),
                                SizedBox(height: 25.h),
                              ],
                            );
                          }).toList(),
                        );
                      }),

                      SizedBox(height: 10.h),

                      Row(
                        children: [
                          Text(
                            "History",
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 9.w),
                          SvgPicture.asset("assets/icons/history_icon.svg",
                              width: 36.w, height: 36.h),
                        ],
                      ),
                      SizedBox(height: 25.h),

                      Obx(() {
                        if (controller.traps.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(32.w),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64.w,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "No tools found for this company",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Tools will appear here once they are added",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.traps.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (_, index) {
                            final item = controller.traps[index];
                            return ToolCard(
                              toolName: item.namaAlat,
                              imagePath: item.imagePath ?? "",
                              location: item.lokasi,
                              locationDetail: item.detailLokasi,
                              historyItems: [],
                              kondisi: item.kondisi,
                              pest_type: item.pestType,
                              kode_qr: item.kodeQr,
                              alatId: item.id.toString(),
                            );
                          },
                        );
                      }),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}