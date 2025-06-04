import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../../data/services/company_service.dart';
import 'data_company_controller.dart';
import 'widgets/CompanyCard.dart';

class DataCompanyView extends StatelessWidget {
  const DataCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataCompanyController());
    final companyService = CompanyService();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Company",
              showBackButton: false,
              rightIcon: "",
              rightOnTap: () {},
              onBackTap: () {},
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.companies.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data perusahaan'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchCompanies,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.companyCount,
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (_, index) {
                        final company = controller.getCompany(index);
                        return CompanyCard(
                          companyName: company.name,
                          imagePath: company.imagePath,
                          companyAddress: company.address,
                        );
                      },
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
