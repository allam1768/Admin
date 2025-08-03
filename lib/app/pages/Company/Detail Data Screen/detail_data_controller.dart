import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../../../../data/models/alat_model.dart';
import '../../../../data/models/chart_model.dart';
import '../../../../data/services/alat_service.dart';
import '../../../../data/services/chart_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class DetailDataController extends GetxController {
  var traps = <AlatModel>[].obs;
  var selectedMonth = 0.obs;
  var isLoadingChart = false.obs;

  var landChartData = <FlSpot>[].obs;
  var flyChartData = <FlSpot>[].obs;

  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;

  var companyId = 0.obs;
  var companyName = ''.obs;
  var companyAddress = ''.obs;
  var companyPhoneNumber = ''.obs;
  var companyEmail = ''.obs;
  var companyImagePath = ''.obs;
  var companyCreatedAt = ''.obs;
  var companyUpdatedAt = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null) {
      companyName.value = arguments['name'] ?? '';
      companyAddress.value = arguments['address'] ?? '';
      companyPhoneNumber.value = arguments['phoneNumber'] ?? '';
      companyEmail.value = arguments['email'] ?? '';
      companyImagePath.value = arguments['imagePath'] ?? '';
      companyCreatedAt.value = arguments['createdAt'] ?? '';
      companyUpdatedAt.value = arguments['updatedAt'] ?? '';
    }

    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);

    _loadCompanyId(); // fetchData dipanggil di dalam sini
  }

  Future<void> _loadCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getInt('companyid') ?? 0;
    print('Loaded Company ID from SharedPreferences: ${companyId.value}');
    if (companyId.value > 0) {
      fetchData(); // Fetch data after ID is loaded
    }
  }

  Future<void> fetchData() async {
    try {
      if (companyId.value > 0) {
        traps.value = await AlatService.fetchAlatByCompany(companyId.value);
        await fetchChartData();
      } else {
        // Handle case where companyId is not available
        traps.value = [];
        Get.snackbar("Error", "Company ID not found. Please select a company.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> fetchChartData() async {
    if (companyId.value <= 0) return;

    try {
      isLoadingChart.value = true;

      final dateFormat = DateFormat('yyyy-MM-dd');
      final startDateStr = dateFormat.format(startDate.value);
      final endDateStr = dateFormat.format(endDate.value);

      final landData = await ChartService.fetchChartData(
        companyId: companyId.value,
        pestType: 'Land',
        startDate: startDateStr,
        endDate: endDateStr,
      );

      final flyData = await ChartService.fetchChartData(
        companyId: companyId.value,
        pestType: 'Flying',
        startDate: startDateStr,
        endDate: endDateStr,
      );

      landChartData.value = _convertToFlSpots(landData);
      flyChartData.value = _convertToFlSpots(flyData);
    } catch (e) {
      landChartData.value = [FlSpot(0, 0)];
      flyChartData.value = [FlSpot(0, 0)];
    } finally {
      isLoadingChart.value = false;
    }
  }

  List<FlSpot> _convertToFlSpots(List<ChartModel> chartData) {
    if (chartData.isEmpty) return [FlSpot(0, 0)];

    Map<String, double> dateValueMap = {};
    for (var data in chartData) {
      final date = data.tanggal;
      final value = data.value.toDouble();
      dateValueMap[date] = (dateValueMap[date] ?? 0) + value;
    }

    List<String> sortedDates = dateValueMap.keys.toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('dd-MM-yyyy').parse(a);
          final dateB = DateFormat('dd-MM-yyyy').parse(b);
          return dateA.compareTo(dateB);
        } catch (_) {
          return a.compareTo(b);
        }
      });

    List<FlSpot> spots = [];

    if (sortedDates.length == 1) {
      final singleDate = sortedDates.first;
      final value = dateValueMap[singleDate] ?? 0;
      spots.add(FlSpot(0, value));
    } else {
      for (int i = 0; i < sortedDates.length; i++) {
        final date = sortedDates[i];
        final value = dateValueMap[date] ?? 0;
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    return spots.isEmpty ? [FlSpot(0, 0)] : spots;
  }

  List<FlSpot> getChartData(String title) {
    if (title == "Land") {
      return landChartData.value;
    } else if (title == "Fly" || title == "Flying") {
      return flyChartData.value;
    }
    return [FlSpot(0, 0)];
  }

  void debugChartData() {
    print('Land Chart: ${landChartData.value}');
    print('Fly Chart: ${flyChartData.value}');
    print('Total Land: $totalLandCatches');
    print('Total Fly: $totalFlyCatches');
  }

  void onDateRangeChanged(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      Get.snackbar("Invalid", "Start date cannot be after end date");
      return;
    }

    final range = end.difference(start).inDays;
    if (range > 365) {
      Get.snackbar("Too Long", "Please choose a range within 1 year");
      return;
    }

    startDate.value = start;
    endDate.value = end;
    fetchChartData();
  }

  void changeDate(DateTime date) {
    print("Tanggal berubah ke: ${date.toString()}");
  }

  void updateNote(int index, String value) {
    print("Updating note for index $index: $value");
  }

  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 0;
    Get.offNamed('/bottomnav');
  }

  String getCompanyInfo() {
    return "${companyName.value} - ${companyAddress.value}";
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  Future<void> retryChartData() async {
    await fetchChartData();
  }

  int get totalPengecekan {
    // Hitung jumlah titik chart yang valid (bukan dummy)
    int countLand = landChartData.where((e) => e.y > 0).length;
    int countFly = flyChartData.where((e) => e.y > 0).length;
    return countLand + countFly;
  }


  bool get hasChartData {
    return landChartData.isNotEmpty &&
        flyChartData.isNotEmpty &&
        !(landChartData.length == 1 && landChartData.first.y == 0) &&
        !(flyChartData.length == 1 && flyChartData.first.y == 0);
  }

  int get totalLandCatches {
    if (landChartData.isEmpty) return 0;
    if (landChartData.length == 3 && landChartData[0].y == 0 && landChartData[1].y == landChartData[2].y) {
      return landChartData[1].y.toInt();
    }
    return landChartData.map((e) => e.y.toInt()).reduce((a, b) => a + b);
  }

  int get totalFlyCatches {
    if (flyChartData.isEmpty) return 0;
    if (flyChartData.length == 3 && flyChartData[0].y == 0 && flyChartData[1].y == flyChartData[2].y) {
      return flyChartData[1].y.toInt();
    }
    return flyChartData.map((e) => e.y.toInt()).reduce((a, b) => a + b);
  }

  String get formattedDateRange {
    final formatter = DateFormat('MMM d, yyyy');
    return '${formatter.format(startDate.value)} - ${formatter.format(endDate.value)}';
  }

  @override
  void onClose() {
    super.onClose();
  }
}