import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailDataController extends GetxController {
  var traps = <Map<String, dynamic>>[
    {
      "name": "anjayyy",
      "image": "assets/images/example.png",
      "location": "Tenggara",
      "locationDetail": "Tenggara",
      "history": [
        {"date": "2024-03-10", "count": 5},
        {"date": "2024-03-17", "count": 3},
      ],
      "isExpanded": false,
      "note": "".obs,
    }
  ].obs;

  var selectedMonth = 0.obs;

  void changeMonth(int index) {
    selectedMonth.value = index;
  }

  void toggleExpand(int index) {
    for (int i = 0; i < traps.length; i++) {
      traps[i]["isExpanded"] = (i == index) ? !(traps[i]["isExpanded"] ?? false) : false;
    }
    traps.refresh();
  }

  void updateNote(int index, String value) {
    traps[index]["note"].value = value;
  }

  List<FlSpot> getChartData(String title) {
    if (title == "Land") {
      return [
        FlSpot(1, 10),
        FlSpot(2, 15),
        FlSpot(3, 7),
        FlSpot(4, 12),
      ];
    } else if (title == "Fly") {
      return [
        FlSpot(1, 10),
        FlSpot(2, 15),
        FlSpot(3, 7),
        FlSpot(4, 12),
      ];
    }
    return [];
  }
}
