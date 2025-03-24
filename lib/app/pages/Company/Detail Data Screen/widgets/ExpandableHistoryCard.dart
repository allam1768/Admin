  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'SingleHistoryCard.dart';

  class ExpandableHistoryCard extends StatefulWidget {
    final String imagePath;
    final String location;
    final List<Map<String, dynamic>> historyItems;
    final bool isExpanded;
    final VoidCallback onTap;

    const ExpandableHistoryCard({
      required this.imagePath,
      required this.location,
      required this.historyItems,
      required this.isExpanded,
      required this.onTap,
      Key? key,
    }) : super(key: key);

    @override
    _ExpandableHistoryCardState createState() => _ExpandableHistoryCardState();
  }

  class _ExpandableHistoryCardState extends State<ExpandableHistoryCard>
      with SingleTickerProviderStateMixin {
    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: widget.isExpanded ? Radius.zero : Radius.circular(12.r),
                bottomRight: widget.isExpanded ? Radius.zero : Radius.circular(12.r),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: 372.w,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 12.w,
                    bottom: 12.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          // ANIMASI EXPANDABLE
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: widget.isExpanded
                ? Container(
              decoration: BoxDecoration(
                color: Color(0xFF97B999), // Hijau tua
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              padding: EdgeInsets.only(top: 0, bottom: 0), // Top 0 biar mepet ke atas
              child: Column(
                children: [
                  ...widget.historyItems
                      .map((item) => SingleHistoryCard(item: item))
                      .toList(),
                  SizedBox(height: 16.h),
                ],
              ),
            )
                : SizedBox(),
          ),
        ],
      );
    }
  }
