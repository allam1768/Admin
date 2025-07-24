import 'package:admin/app/pages/Client/Data%20Client%20Screen/data_client_controller.dart';
import 'package:admin/app/pages/Client/Data%20Client%20Screen/widgets/ClientCard.dart';
import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global component/CustomAppBar.dart';

class DataClientView extends StatelessWidget {
  const DataClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataClientController());

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Client",
              rightIcon: "assets/icons/add_client_btn.svg",
              rightOnTap: controller.goToCreateClient,
              showBackButton: false,
              onBackTap: () {},
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(
                    color: AppColor.btnijo,
                  ),);
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchClients,
                  child: controller.clients.isEmpty
                      ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 0.7.sh, // Using ScreenUtil for screen height
                        child: Center(
                          child: Text(
                            "Belum ada data client.",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  )
                      : ListView.separated(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 20.h),
                    itemCount: controller.clients.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemBuilder: (_, index) {
                      final clientData = controller.clients[index];

                      String? imageUrl;
                      bool isNetworkImage = false;

                      if (clientData.image != null &&
                          clientData.image!.isNotEmpty) {
                        if (clientData.image!.startsWith('http')) {
                          imageUrl = clientData.image!;
                          isNetworkImage = true;
                        } else {
                          imageUrl =
                          'https://hamatech.rplrus.com/storage/${clientData.image}';
                          isNetworkImage = true;
                        }
                      }

                      return ClientCard(
                        client: clientData.name,
                        imagePath: imageUrl,
                        isNetworkImage: isNetworkImage,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}