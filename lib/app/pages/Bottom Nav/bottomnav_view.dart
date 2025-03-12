import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Data Client Screen/data_client_view.dart';
import '../Data Company Screen/data_company_view.dart';
import '../Data Worker Screen/data_worker_view.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const DataCompanyView(),
    const DataClientView(),
    const DataWorkerView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCD7CD),
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 35.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          margin: EdgeInsets.symmetric(horizontal: 35.w),
          decoration: BoxDecoration(
            color: const Color(0xFFA3B8A3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              final List<String> icons = [
                "assets/icons/Company_icont.svg",
                "assets/icons/Client_icont.svg",
                "assets/icons/Worker_icont.svg"
              ];
              bool isActive = currentIndex == index;

              return GestureDetector(
                onTap: () => onTabTapped(index),
                child: Container(
                  height: 50.r,
                  width: 50.r,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF184D2B) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icons[index],
                      color: isActive ? Colors.black : Colors.grey,
                      width: 15.w,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
