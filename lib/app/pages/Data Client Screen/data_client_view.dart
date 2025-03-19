import 'package:admin/app/pages/Data%20Client%20Screen/data_client_controller.dart';
import 'package:admin/app/pages/Data%20Client%20Screen/widgets/ClientCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../global component/app_bar.dart';

class DataClientView extends StatelessWidget {
  const DataClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataClientController());

    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Client",
              rightIcon: "assets/icons/add_client_btn.svg",
              rightOnTap: () {
                Get.offNamed('/add-client'); // Ganti dengan rute yang benar
              },
              showBackButton: false,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Obx(() => ListView.separated(
                  itemCount: controller.clients.length,
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
                  itemBuilder: (context, index) {
                    return ClientCard(
                      company: controller.clients[index]["company"]!,
                      client: controller.clients[index]["client"]!,
                      imagePath: controller.clients[index]["imagePath"]!,
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
