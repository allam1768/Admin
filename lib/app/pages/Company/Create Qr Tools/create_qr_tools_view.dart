import 'package:admin/app/global%20component/CustomButton.dart';
import 'package:admin/app/global%20component/ImageUpload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global component/CustomTextField.dart';
import '../../../global component/app_bar.dart';
import 'create_qr_tools_controller.dart';

class CreateQrView extends StatelessWidget {
  CreateQrView({super.key});

  final CreateQrController controller = Get.put(CreateQrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Create Qr"),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: 250.h,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/input_illustration.svg',
                          width: 310.w,
                        ),
                      ),
                    ),

                    Container(
                      color: const Color(0xFFBBD4C3),
                      padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: "Name",
                            onChanged: (value) => controller.name.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.name.value.isEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Name harus diisi!",
                              style: TextStyle(fontSize: 14.sp, color: Colors.red),
                            ),
                          )
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          CustomTextField(
                            label: "Area",
                            onChanged: (value) => controller.area.value = value,
                          ),
                          Obx(() => controller.showError.value && controller.area.value.isEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Area harus diisi!",
                              style: TextStyle(fontSize: 14.sp, color: Colors.red),
                            ),
                          )
                              : SizedBox()),
                          SizedBox(height: 15.h),

                          Text(
                            "Type",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5.h),

                          Obx(() => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: controller.showError.value && controller.selectedType.value == null
                                    ? Colors.red
                                    : Colors.transparent,
                              ),
                            ),
                            child: DropdownMenu<String>(
                              enableSearch: false,
                              onSelected: (value) => controller.selectedType.value = value,
                              width: 340.w,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: 'Darat', label: 'Darat'),
                                DropdownMenuEntry(value: 'Terbang', label: 'Terbang'),
                              ],
                            ),
                          )),
                          Obx(() => controller.showError.value && controller.selectedType.value == null
                              ? Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Type harus dipilih!",
                              style: TextStyle(fontSize: 14.sp, color: Colors.red),
                            ),
                          )
                              : SizedBox()),

                          SizedBox(height: 15.h),

                          ImageUpload(
                            imageFile: controller.imageFile,
                            imageError: controller.imageError,
                          ),

                          SizedBox(height: 20.h),

                          CustomButton(
                            text: "Create Qr",
                            color: Color(0xFF275637),
                            onPressed: () {
                              controller.validateForm();
                            },
                            fontSize: 20,
                          ),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
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
