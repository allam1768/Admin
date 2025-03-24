import 'package:get/get.dart';

class DetailDataController extends GetxController {
  var traps = <Map<String, dynamic>>[
    {
      "image": "assets/images/example.png",
      "location": "Tenggara",
      "history": [
        {"date": "2024-03-10", "count": 5},
        {"date": "2024-03-17", "count": 3},
      ],
      "isExpanded": false,
      "note": "".obs, // Tambahin note
    },
    {
      "image": "assets/images/example.png",
      "location": "Barat",
      "history": [
        {"date": "2024-03-10", "count": 5},
        {"date": "2024-03-17", "count": 3},
      ],
      "isExpanded": false,
      "note": "".obs, // Tambahin note
    },
    {
      "image": "assets/images/example.png",
      "location": "Selatan",
      "history": [
        {"date": "2024-03-10", "count": 5},
        {"date": "2024-03-17", "count": 3},
      ],
      "isExpanded": false,
      "note": "".obs, // Tambahin note
    },
    {
      "image": "assets/images/example.png",
      "location": "Timur",
      "history": [
        {"date": "2024-03-12", "count": 2},
        {"date": "2024-03-18", "count": 7},
      ],
      "isExpanded": false,
      "note": "".obs, // Tambahin note
    },
  ].obs;

  void toggleExpand(int index) {
    for (int i = 0; i < traps.length; i++) {
      traps[i]["isExpanded"] = (i == index) ? !(traps[i]["isExpanded"] ?? false) : false;
    }
    traps.refresh();
  }


  void updateNote(int index, String value) {
    traps[index]["note"].value = value;
  }
}
