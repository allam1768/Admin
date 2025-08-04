import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../values/app_color.dart';
import '../../../../../data/models/alat_model.dart';
import '../../../../global component/CustomAppBar.dart';
import '../../../../global component/CustomButton.dart';
import '../../../../global component/CustomDropdown.dart';
import '../../../../global component/CustomTextField.dart';
import '../../../../global component/ImageUpload.dart';
import 'update_qr_tools_controller.dart';

class EditToolView extends StatefulWidget {
  const EditToolView({super.key});

  @override
  State<EditToolView> createState() => _EditToolViewState();
}

class _EditToolViewState extends State<EditToolView> {
  final controller = Get.put(EditToolController());

  @override
  void initState() {
    super.initState();
    final alat = Get.arguments as AlatModel;
    controller.init(alat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Edit Alat",
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/input_illustration.svg',
                        width: 310.w,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: "Nama Alat",
                            controller: controller.namaController,
                            onChanged: (val) =>
                                controller.namaController.text = val,
                          ),
                          SizedBox(height: 15.h),
                          CustomTextField(
                            label: "Lokasi",
                            controller: controller.lokasiController,
                            onChanged: (val) =>
                                controller.lokasiController.text = val,
                          ),
                          SizedBox(height: 15.h),
                          CustomTextField(
                            label: "Detail Lokasi",
                            controller: controller.detailLokasiController,
                            onChanged: (val) =>
                                controller.detailLokasiController.text = val,
                          ),
                          SizedBox(height: 15.h),

                          GetX<EditToolController>(
                            builder: (c) => CustomDropdown(
                              label: "Tipe",
                              value: c.selectedType.value,
                              hintText: "Pilih tipe...",
                              items: const [
                                DropdownMenuItem(
                                  value: 'Rodent Bait Station',
                                  child: Text('Rodent Bait Station'),
                                ),
                                DropdownMenuItem(
                                  value: 'Rodent Glue Traps',
                                  child: Text('Rodent Glue Traps'),
                                ),
                                DropdownMenuItem(
                                  value: 'Rodent Life Trap',
                                  child: Text('Rodent Life Trap'),
                                ),
                                DropdownMenuItem(
                                  value: 'Fly Catchers Lamp',
                                  child: Text('Fly Catchers Lamp'),
                                ),
                                DropdownMenuItem(
                                  value: 'Fly Trap Glue Stick',
                                  child: Text('Fly Trap Glue Stick'),
                                ),

                              ],
                              onChanged: (val) => c.selectedType.value = val,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          GetX<EditToolController>(
                            builder: (c) => CustomDropdown(
                              label: "Kondisi",
                              value: c.selectedKondisi.value,
                              hintText: "Pilih kondisi...",
                              items: const [
                                DropdownMenuItem(
                                    value: 'good', child: Text('Aktif')),
                                DropdownMenuItem(
                                    value: 'broken', child: Text('Tidak aktiif')),
                              ],
                              onChanged: (val) => c.selectedKondisi.value = val,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          // Upload Gambar
                          ImageUpload(
                            imageFile: controller.imageFile,
                            title: "Foto Alat",
                            imageUrl: controller.currentAlat.imagePath,
                          ),

                          SizedBox(height: 50.h),

                          CustomButton(
                            text: controller.isLoading.value
                                ? "Loading..."
                                : "Simpan",
                            backgroundColor: AppColor.btnoren,
                            onPressed: controller.validateForm,
                            fontSize: 20,
                          ),
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
