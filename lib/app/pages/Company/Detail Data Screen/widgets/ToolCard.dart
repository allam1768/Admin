import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../data/models/alat_model.dart';
import '../detail_data_controller.dart';

class ToolCard extends StatefulWidget {
  final String toolName;
  final String imagePath;
  final String location;
  final String locationDetail;
  final String kondisi;
  final String kode_qr;
  final String pest_type;
  final String alatId;
  final List<Map<String, dynamic>> historyItems;

  const ToolCard({
    super.key,
    required this.toolName,
    required this.imagePath,
    required this.location,
    required this.locationDetail,
    required this.historyItems,
    required this.kondisi,
    required this.kode_qr,
    required this.pest_type,
    required this.alatId,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  bool _showImage = false;

  @override
  Widget build(BuildContext context) {
    String normalized = widget.kondisi.trim().toLowerCase();
    Color statusColor;
    if (normalized == 'good' || normalized == 'baik') {
      statusColor = AppColor.btnijo;
    } else if (normalized == 'broken' || normalized == 'rusak') {
      statusColor = Colors.grey;
    } else if (normalized == 'maintenance') {
      statusColor = AppColor.oren;
    } else {
      statusColor = Colors.grey;
    }

    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => Get.toNamed('/historytool', arguments: {
            'alatId': widget.alatId,
            'toolName': widget.toolName,
            'location': widget.location,
            'locationDetail': widget.locationDetail,

          }),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showImage)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          widget.imagePath,
                          width: double.infinity,
                          height: 180.h,
                          fit: BoxFit.cover,
                          headers: {
                            'ngrok-skip-browser-warning': '1',
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/broken.png',
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            widget.toolName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.location,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.locationDetail,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    normalized == 'good' || normalized == 'baik'
                                        ? Icons.check_circle
                                        : normalized == 'broken' || normalized == 'rusak'
                                        ? Icons.cancel
                                        : normalized == 'maintenance'
                                        ? Icons.build_circle
                                        : Icons.help_outline,
                                    size: 14.sp,
                                    color: statusColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    (normalized == 'good' || normalized == 'baik') ? 'Aktif' : 'Tidak Aktif',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: (normalized == 'good' || normalized == 'baik') ? Colors.green : Colors.grey,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 4.h),

                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        IconButton(
                          icon: Icon(
                            _showImage ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 20.sp,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _showImage = !_showImage;
                            });
                          },
                        ),
                        SizedBox(width: 4.w),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            size: 20.sp,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {
                            final item = Get.find<DetailDataController>()
                                .traps
                                .firstWhere(
                                  (trap) =>
                              trap.namaAlat == widget.toolName &&
                                  trap.lokasi == widget.location,
                              orElse: () => AlatModel(
                                id: 0,
                                namaAlat: '',
                                lokasi: '',
                                pestType: '',
                                kondisi: '',
                                kodeQr: '',
                                detailLokasi: '',
                              ),
                            );

                            if (item.id > 0) {
                              Get.toNamed('/detailtool', arguments: {
                                'id': item.id,
                                'toolName': widget.toolName,
                                'imagePath': widget.imagePath,
                                'location': widget.location,
                                'locationDetail': widget.locationDetail,
                                'kondisi': widget.kondisi,
                                'kodeQr': widget.kode_qr,
                                'pestType': widget.pest_type,
                                'alatId': widget.alatId,
                              });
                            } else {
                              Get.snackbar(
                                'Error',
                                'Data alat tidak ditemukan',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
