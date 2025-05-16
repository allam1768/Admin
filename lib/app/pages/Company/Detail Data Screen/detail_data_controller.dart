import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../data/models/alat_model.dart';
import '../../../../data/services/alat_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';


class DetailDataController extends GetxController {
  var traps = <AlatModel>[].obs;
  var selectedMonth = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      traps.value = await AlatService.fetchAlat();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void changeMonth(int index) {
    selectedMonth.value = index;
  }



  void updateNote(int index, String value) {

  }

  List<FlSpot> getChartData(String title) {
    // Dummy chart data
    return [
      FlSpot(1, 10),
      FlSpot(2, 15),
      FlSpot(3, 7),
      FlSpot(4, 12),
    ];
  }
  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 0;
    Get.offNamed('/bottomnav'); // Ganti dengan nama screen yang ada bottom nav-nya
  }
}
