import 'package:get/get.dart';

class HistoryController extends GetxController {
  RxList<Map<String, dynamic>> historyData = <Map<String, dynamic>>[].obs;

  Map<String, String> monthNames = {
    "01": "January",
    "02": "February",
    "03": "March",
    "04": "April",
    "05": "May",
    "06": "June",
    "07": "July",
    "08": "August",
    "09": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    historyData.value = [
      {"name": "Wawan", "date": "12.01.2023", "time": "12.00"},
      {"name": "Wawan", "date": "15.01.2023", "time": "13.00"},
      {"name": "Wawan", "date": "20.01.2023", "time": "14.00"},
      {"name": "Wawan", "date": "25.01.2023", "time": "15.00"},
      {"name": "Wawan", "date": "05.02.2023", "time": "10.00"},
      {"name": "Wawan", "date": "10.02.2023", "time": "11.00"},
      {"name": "Wawan", "date": "20.02.2023", "time": "12.00"},
      {"name": "Wawan", "date": "25.02.2023", "time": "13.00"},
      {"name": "Wawan", "date": "05.03.2023", "time": "09.00"},
      {"name": "Wawan", "date": "8.03.2023", "time": "09.00"},
      {"name": "Wawan", "date": "9.03.2023", "time": "09.00"},
      {"name": "Wawan", "date": "11.03.2023", "time": "09.00"},
      {"name": "Wawan", "date": "10.6.2023", "time": "09.00"},
    ];
  }

  Map<String, List<Map<String, dynamic>>> groupByMonth() {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var item in historyData) {
      String monthKey = getMonthYearKey(item["date"]);

      if (!groupedData.containsKey(monthKey)) {
        groupedData[monthKey] = [];
      }
      groupedData[monthKey]!.add(item);
    }

    return groupedData;
  }

  String getMonthYearKey(String date) {
    List<String> splitDate = date.split(".");
    return "${splitDate[1]}.${splitDate[2]}"; // MM.YYYY
  }

  String getMonthName(String monthKey) {
    String month = monthKey.split(".")[0];
    return monthNames[month] ?? "Unknown";
  }
}
