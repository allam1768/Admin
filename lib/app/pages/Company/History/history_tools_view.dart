import 'package:admin/app/pages/Company/History/widgets/SingleHistoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
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
            CustomAppBar(
              title: Get.arguments?['toolName'] ,
            ),


            Obx(() {
              var groupedHistory = controller.groupByMonth();
              var sortedKeys = groupedHistory.keys.toList()
                ..sort((b, a) => a.compareTo(b));

              if (controller.historyData.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "Belum ada data",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  children: sortedKeys.expand((month) {
                    var items = groupedHistory[month]!;
                    return items.map((item) => SingleHistoryCard(item: item));
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
