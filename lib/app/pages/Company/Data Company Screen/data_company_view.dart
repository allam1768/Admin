import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/app_bar.dart';
import 'data_company_controller.dart';
import 'widgets/CompanyCard.dart';

class DataCompanyView extends StatelessWidget {
  const DataCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataCompanyController()); // Get.put() saat pertama kali akses

    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Company",
              showBackButton: false,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(() => ListView.separated(
                  itemCount: controller.companies.length,
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
                  itemBuilder: (context, index) {
                    return CompanyCard(
                      companyName: controller.companies[index]["name"]!,
                      imagePath: controller.companies[index]["image"]!,
                    );
                  },
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
