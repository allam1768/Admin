import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Data Client Screen/data_client_view.dart';
import '../Data Company Screen/data_company_view.dart';
import '../Data Worker Screen/data_worker_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> icons = [
      "assets/icons/Company_icont.svg",
      "assets/icons/Client_icont.svg",
      "assets/icons/Worker_icont.svg"
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: 35.h), // Jarak ke bawah 35.h
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFA3B8A3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            bool isActive = currentIndex == index;

            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: 50.r,
                width: 50.r,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF184D2B) : Colors.white, // Warna hijau tua jika aktif
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icons[index],
                    color: isActive ? Colors.black : Colors.grey, // Icon aktif hitam, tidak aktif abu-abu
                    width: 15.w,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
