import 'package:get/get.dart';

class HistoryReportController extends GetxController {
  var reports = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    reports.addAll([
      {
        "name": "Wawan",
        "date": "14.02.2024",
        "time": "09.30",
        "role": "worker",
      },
      {
        "name": "Budi",
        "date": "14.02.2024",
        "time": "10.15",
        "role": "client",
      },
      {
        "name": "Andi",
        "date": "13.02.2024",
        "time": "14.20",
        "role": "worker",
      },
      {
        "name": "Siti",
        "date": "13.02.2024",
        "time": "15.45",
        "role": "client",
      },
      {
        "name": "Deni",
        "date": "12.02.2024",
        "time": "08.00",
        "role": "worker",
      },
      {
        "name": "Rini",
        "date": "12.02.2024",
        "time": "11.30",
        "role": "client",
      },
    ]);
  }

  // ✅ Sudah termasuk 'role' biar bisa ditampilkan
  void addReport(String name, String date, String time, String role) {
    reports.add({
      "name": name,
      "date": date,
      "time": time,
      "role": role,
    });
  }
}
