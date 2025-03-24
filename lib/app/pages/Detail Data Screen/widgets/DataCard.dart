import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphic/graphic.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> dataPoints;
  final Function(String) onNoteChanged;
  final VoidCallback onSave;
  final Color? color;

  const DataCard({
    super.key,
    required this.title,
    required this.dataPoints,
    required this.onNoteChanged,
    required this.onSave,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF97B999),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          Text(
            title,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 54.h),

          // Diagram Batang (dengan label minggu)
          SizedBox(
            height: 175.h,
            child: Chart(
              data: dataPoints,
              variables: {
                'x': Variable(
                  accessor: (Map map) => map['x'].toString(),
                  scale: OrdinalScale(tickCount: dataPoints.length),
                ),
                'y': Variable(
                  accessor: (Map map) => map['y'] as num,
                  scale: LinearScale(),
                ),
              },
              marks: [
                IntervalMark(
                  position: Varset('x') * Varset('y'),
                  color: ColorEncode(
                    variable: 'x',
                    values: List.generate(dataPoints.length, (index) => Colors.purple[200]!),
                  ),
                  shape: ShapeEncode(
                    value: RectShape(borderRadius: BorderRadius.circular(4.r)), // Membuat ujung batang tumpul
                  ),
                ),
              ],
              axes: [
                Defaults.horizontalAxis..label = LabelStyle(
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp), // Warna label sumbu X jadi hitam
                ),
                Defaults.verticalAxis,
              ],
            ),
          ),
          SizedBox(height: 42.h),

          // Input Catatan
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              onChanged: onNoteChanged,
              minLines: 1,
              maxLines: 5,
              style: TextStyle(fontSize: 14.sp),
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Tambah catatan...",
                hintStyle: TextStyle(fontSize: 14.sp),
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(
                    "assets/icons/note_icont.svg",
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Tombol Save di Bawah
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                backgroundColor: Color(0xFFFFA726),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save_rounded, color: Colors.black, size: 18.r),
                  SizedBox(width: 6.w),
                  Text(
                    "Save",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
