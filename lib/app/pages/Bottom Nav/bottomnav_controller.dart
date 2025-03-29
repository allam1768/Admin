import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Client/Data Client Screen/data_client_view.dart';
import '../Company/Data Company Screen/data_company_view.dart';
import '../Worker/Data Worker Screen/data_worker_view.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> screens = [
    const DataCompanyView(),
    const DataClientView(),
    const DataWorkerView(),
  ];

  final List<String> icons = [
    "assets/icons/Company_icont.svg",
    "assets/icons/Client_icont.svg",
    "assets/icons/Worker_icont.svg"
  ];

  RxInt get selectedIndex => currentIndex; // Tambahkan getter agar bisa diakses

  void changeTab(int index) {
    currentIndex.value = index;
  }

  bool isActive(int index) => currentIndex.value == index;
}
