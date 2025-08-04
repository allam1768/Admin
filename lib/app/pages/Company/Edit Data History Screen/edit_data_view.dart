import 'package:admin/app/pages/Company/Edit%20Data%20History%20Screen/widgets/CustomButtonEdit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../values/app_color.dart';
import '../../../global component/CustomAppBar.dart';
import '../../../global component/ImageUpload.dart';
import 'edit_data_controller.dart';
import 'dart:io';

import 'widgets/CustomTextFieldEdit.dart';

class EditDataView extends StatelessWidget {
  EditDataView({super.key});

  final EditDataController controller = Get.put(EditDataController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Ambil nama alat dari arguments
    final String namaAlat = Get.arguments?['name'] ??
        Get.arguments?['nama_alat'] ??
        'Edit Data';

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Edit $namaAlat", onBackTap: ()=> Get.back(),),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Image
                    Container(
                      height: screenHeight * 0.15,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/input.svg',
                        width: screenWidth * 0.6,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Form Container
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Condition Section
                          Text(
                            "Condition",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: screenWidth * 0.015),
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.008,
                                          horizontal: screenWidth * 0.015),
                                      decoration: BoxDecoration(
                                        color: controller.selectedCondition
                                            .value ==
                                            "Good"
                                            ? AppColor.oren
                                            .withOpacity(0.08)
                                            : Colors.white,
                                        border: Border.all(
                                          color: controller.conditionError
                                              .value.isNotEmpty
                                              ? Colors.red
                                              : (controller
                                              .selectedCondition
                                              .value ==
                                              "Good"
                                              ? AppColor.oren
                                              : Colors.grey.shade300),
                                          width: 1,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: "Good",
                                            groupValue: controller
                                                .selectedCondition.value,
                                            onChanged:
                                            controller.setCondition,
                                            activeColor: AppColor.oren,
                                            materialTapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                            visualDensity:
                                            VisualDensity.compact,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.01),
                                          Text(
                                            "Aktif",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: screenWidth * 0.015),
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.008,
                                          horizontal: screenWidth * 0.015),
                                      decoration: BoxDecoration(
                                        color: controller.selectedCondition
                                            .value ==
                                            "Broken"
                                            ? AppColor.oren
                                            .withOpacity(0.08)
                                            : Colors.white,
                                        border: Border.all(
                                          color: controller.conditionError
                                              .value.isNotEmpty
                                              ? Colors.red
                                              : (controller
                                              .selectedCondition
                                              .value ==
                                              "Broken"
                                              ? AppColor.oren
                                              : Colors.grey.shade300),
                                          width: 1,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: "Broken",
                                            groupValue: controller
                                                .selectedCondition.value,
                                            onChanged:
                                            controller.setCondition,
                                            activeColor: AppColor.oren,
                                            materialTapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                            visualDensity:
                                            VisualDensity.compact,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.01),
                                          Text(
                                            "Tidak Aktif",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() =>
                              controller.conditionError.value.isNotEmpty
                                  ? Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.02,
                                    top: screenHeight * 0.008),
                                child: Text(
                                  controller.conditionError.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink()),
                            ],
                          )),
                          SizedBox(height: screenHeight * 0.01),

                          // Jumlah Field
                          Obx(() => CustomTextFieldEdit(
                            label: "Jumlah",
                            initialValue: controller.jumlah.value,
                            onChanged: controller.setJumlah,
                            errorMessage: controller.jumlahError,
                            keyboardType: TextInputType.number,
                          )),
                          SizedBox(height: screenHeight * 0.015),

                          // --- UPDATED: Jenis Hama Section with Dropdown ---
                          Text(
                            "Jenis Hama",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedPest.value.isEmpty ? null : controller.selectedPest.value,
                            items: [
                              ...controller.pestOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              DropdownMenuItem<String>(
                                value: "Other", // Value for custom input
                                child: Text("Lainnya (ketik manual)"),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != "Other") {
                                controller.setSelectedPest(newValue!);
                                controller.showCustomPestField.value = false;
                              } else {
                                controller.showCustomPestField.value = true;
                                controller.setSelectedPest('');
                                controller.setCustomPestText(''); // Clear custom text when switching
                              }
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey.shade600),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: controller.jenisHamaError.value.isNotEmpty ? Colors.red : Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: controller.jenisHamaError.value.isNotEmpty ? Colors.red : Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF275637),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.04,
                              ),
                              errorText: controller.jenisHamaError.value.isNotEmpty ? controller.jenisHamaError.value : null,
                            ),
                          )),
                          // Field input for Other Pest Type
                          Obx(() => controller.showCustomPestField.value
                              ? Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: CustomTextFieldEdit(
                              label: "Jenis Hama Lainnya",
                              initialValue: controller.customPestText.value,
                              onChanged: controller.setCustomPestText, // Use setCustomPestText instead
                              errorMessage: controller.jenisHamaError,
                            ),
                          )
                              : const SizedBox.shrink()),
                          // --- END UPDATED SECTION ---

                          SizedBox(height: screenHeight * 0.015),

                          // Catatan Field
                          Obx(() => CustomTextFieldEdit(
                            label: "Catatan",
                            initialValue: controller.catatan.value,
                            onChanged: controller.setCatatan,
                            errorMessage: controller.catatanError,
                          )),
                          SizedBox(height: screenHeight * 0.02),

                          // Image Upload with existing image URL
                          Obx(() => ImageUpload(
                            imageFile: controller.imageFile,
                            imageError: controller.imageError,
                            title: "Foto Dokumentasi",
                            imageUrl: controller.getCurrentImageUrl(),
                          )),
                          SizedBox(height: screenHeight * 0.03),

                          // Save Button
                          Obx(() => CustomButtonEdit(
                            text: controller.isSaving.value ? "Menyimpan..." : "Simpan Perubahan",
                            backgroundColor: controller.isSaving.value
                                ? Colors.grey
                                : AppColor.btnoren,
                            onPressed: controller.isSaving.value
                                ? null
                                : controller.saveCatch,
                            fontSize: screenWidth * 0.04,
                          )),
                          SizedBox(height: screenHeight * 0.06),
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