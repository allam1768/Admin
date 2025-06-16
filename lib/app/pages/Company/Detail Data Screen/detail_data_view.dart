import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/DataCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/ToolCard.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/DateSelection.dart';
import 'package:admin/app/pages/Company/Detail%20Data%20Screen/widgets/SummarySection.dart';
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
                        totalPengecekan: 4,
                        onQrTap: () => Get.offNamed('/CreateQrTools', arguments: {
                          'companyId': controller.companyId.value,
                        }),
                      )),
                      SizedBox(height: 20.h),
                      MonthSelection(
                        onMonthRangeChanged: (startDate, endDate) {},
                      ),
                      SizedBox(height: 20.h),
                      DataCard(
                        title: "Land",
                        chartData: controller.getChartData("Land"),
                        onNoteChanged: (text) => controller.updateNote(0, text),
                        onSave: () => print("Data Land disimpan!"),
                        color: AppColor.ijomuda,
                      ),
                      SizedBox(height: 25.h),
                      DataCard(
                        title: "Fly",
                        chartData: controller.getChartData("Fly"),
                        onNoteChanged: (text) => controller.updateNote(1, text),
                        onSave: () => print("Data Fly disimpan!"),
                        color: AppColor.ijomuda,
                      ),
                      SizedBox(height: 35.h),
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

                                Text(
                                  "No tools found for this company",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),

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