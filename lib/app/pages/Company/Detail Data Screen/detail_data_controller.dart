import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/alat_model.dart';
import '../../../../data/models/chart_model.dart';
import '../../../../data/services/alat_service.dart';
import '../../../../data/services/chart_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class DetailDataController extends GetxController {
  var traps = <AlatModel>[].obs;
  var selectedMonth = 0.obs;
  var isLoadingChart = false.obs;

  // Modified for layered charts
  var pestTypeLayeredData = <String, Map<String, List<FlSpot>>>{}.obs; // pest_type -> label -> data
  var pestTypeLabelColors = <String, Map<String, Color>>{}.obs; // pest_type -> label -> color
  var availablePestTypes = <String>[].obs;

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

  // Extended color palette for multiple layers
  final List<Color> _colorPalette = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.grey,
    // Light variations
    const Color(0xFF64B5F6), // Light Blue
    const Color(0xFFEF5350), // Light Red
    const Color(0xFF66BB6A), // Light Green
    const Color(0xFFFF9800), // Light Orange
    const Color(0xFFAB47BC), // Light Purple
    const Color(0xFF26A69A), // Light Teal
    const Color(0xFFEC407A), // Light Pink
    const Color(0xFFFFCA28), // Light Amber
  ];

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

    _loadCompanyId();
  }

  Future<void> _loadCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getInt('companyid') ?? 0;
    print('Loaded Company ID from SharedPreferences: ${companyId.value}');
    if (companyId.value > 0) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      if (companyId.value > 0) {
        traps.value = await AlatService.fetchAlatByCompany(companyId.value);
        await fetchChartData();
      } else {
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

      print('Fetching chart data for company: ${companyId.value}');
      print('Date range: $startDateStr to $endDateStr');

      final allChartData = await ChartService.fetchAllChartData(
        companyId: companyId.value,
        startDate: startDateStr,
        endDate: endDateStr,
      );

      print('Received ${allChartData.length} chart data items');
      _processLayeredChartData(allChartData);
    } catch (e) {
      print('Error fetching chart data: $e');
      pestTypeLayeredData.clear();
      availablePestTypes.clear();
      pestTypeLabelColors.clear();
      Get.snackbar("Chart Error", "Failed to load chart data: ${e.toString()}");
    } finally {
      isLoadingChart.value = false;
    }
  }

  void _processLayeredChartData(List<ChartModel> allData) {
    // Clear previous data
    pestTypeLayeredData.clear();
    pestTypeLabelColors.clear();
    availablePestTypes.clear();

    print('Processing ${allData.length} chart data items for layered charts');

    if (allData.isEmpty) {
      print('No chart data to process');
      return;
    }

    // Debug: Print all received data
    for (var item in allData) {
      print('Chart item: pest_type="${item.pestType}", label="${item.label}", value=${item.value}, date=${item.tanggal}');
    }

    // Group data by pest_type, then by label
    Map<String, Map<String, List<ChartModel>>> groupedData = {};

    for (var item in allData) {
      String pestType = item.pestType.trim();
      String label = item.label.trim();

      if (pestType.isEmpty) {
        pestType = 'Unknown';
      }
      if (label.isEmpty) {
        label = 'Unknown Label';
      }

      // Initialize pest_type if not exists
      if (!groupedData.containsKey(pestType)) {
        groupedData[pestType] = {};
      }

      // Initialize label within pest_type if not exists
      if (!groupedData[pestType]!.containsKey(label)) {
        groupedData[pestType]![label] = [];
      }

      groupedData[pestType]![label]!.add(item);
    }

    print('Grouped data structure:');
    groupedData.forEach((pestType, labelMap) {
      print('  PestType: $pestType');
      labelMap.forEach((label, data) {
        print('    Label: $label (${data.length} items)');
      });
    });

    // Convert to layered chart data
    int globalColorIndex = 0;

    groupedData.forEach((pestType, labelMap) {
      availablePestTypes.add(pestType);

      // Initialize maps for this pest type
      pestTypeLayeredData[pestType] = {};
      pestTypeLabelColors[pestType] = {};

      // Process each label within this pest type
      labelMap.forEach((label, data) {
        // Convert data to FlSpots
        pestTypeLayeredData[pestType]![label] = _convertToFlSpots(data);

        // Assign unique color for this label
        Color assignedColor = _colorPalette[globalColorIndex % _colorPalette.length];
        pestTypeLabelColors[pestType]![label] = assignedColor;

        print('Processed: "$pestType" -> "$label": ${data.length} items, color: $assignedColor');
        globalColorIndex++;
      });
    });

    print('Final processed pest types: ${availablePestTypes.toList()}');
    print('Layered data keys: ${pestTypeLayeredData.keys.toList()}');
  }

  List<FlSpot> _convertToFlSpots(List<ChartModel> chartData) {
    if (chartData.isEmpty) return [FlSpot(0, 0)];

    // Group by date and sum values
    Map<String, double> dateValueMap = {};
    for (var data in chartData) {
      final date = data.tanggal;
      final value = data.value.toDouble();
      dateValueMap[date] = (dateValueMap[date] ?? 0) + value;
    }

    // Sort dates
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

  // NEW METHODS FOR LAYERED CHARTS

  // Get all layered chart data for specific pest type
  List<List<FlSpot>> getLayeredChartDataByPestType(String pestType) {
    Map<String, List<FlSpot>>? labelData = pestTypeLayeredData[pestType];
    if (labelData == null || labelData.isEmpty) {
      return [[FlSpot(0, 0)]];
    }

    return labelData.values.toList();
  }

  // Get all colors for layers of specific pest type
  List<Color> getLayeredColorsByPestType(String pestType) {
    Map<String, Color>? labelColors = pestTypeLabelColors[pestType];
    if (labelColors == null || labelColors.isEmpty) {
      return [Colors.grey];
    }

    return labelColors.values.toList();
  }

  // Get labels for specific pest type (for legend)
  List<String> getLabelsByPestType(String pestType) {
    Map<String, List<FlSpot>>? labelData = pestTypeLayeredData[pestType];
    if (labelData == null || labelData.isEmpty) {
      return ['No Data'];
    }

    return labelData.keys.toList();
  }

  // Get color for specific pest type and label
  Color getColorByPestTypeAndLabel(String pestType, String label) {
    return pestTypeLabelColors[pestType]?[label] ?? Colors.grey;
  }

  // LEGACY METHODS (kept for backward compatibility)

  // Get chart data for specific pest type (returns first layer only)
  List<FlSpot> getChartDataByPestType(String pestType) {
    List<List<FlSpot>> layeredData = getLayeredChartDataByPestType(pestType);
    return layeredData.isNotEmpty ? layeredData.first : [FlSpot(0, 0)];
  }

  // Get color for specific pest type (returns first color only)
  Color getColorByPestType(String pestType) {
    List<Color> layeredColors = getLayeredColorsByPestType(pestType);
    return layeredColors.isNotEmpty ? layeredColors.first : Colors.grey;
  }

  // Get total catches for specific pest type (sum all layers)
  int getTotalCatchesByPestType(String pestType) {
    Map<String, List<FlSpot>>? labelData = pestTypeLayeredData[pestType];
    if (labelData == null || labelData.isEmpty) return 0;

    int total = 0;
    labelData.values.forEach((data) {
      if (data.isNotEmpty && !(data.length == 1 && data.first.y == 0)) {
        total += data.map((e) => e.y.toInt()).reduce((a, b) => a + b);
      }
    });
    return total;
  }

  // Get total catches for specific pest type and label
  int getTotalCatchesByPestTypeAndLabel(String pestType, String label) {
    List<FlSpot>? data = pestTypeLayeredData[pestType]?[label];
    if (data == null || data.isEmpty) return 0;
    if (data.length == 1 && data.first.y == 0) return 0;
    return data.map((e) => e.y.toInt()).reduce((a, b) => a + b);
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
    int total = 0;
    pestTypeLayeredData.forEach((pestType, labelMap) {
      labelMap.forEach((label, data) {
        total += data.where((e) => e.y > 0).length;
      });
    });
    return total;
  }

  bool get hasChartData {
    return availablePestTypes.isNotEmpty &&
        pestTypeLayeredData.values.any((labelMap) =>
            labelMap.values.any((data) =>
            data.isNotEmpty && !(data.length == 1 && data.first.y == 0)
            )
        );
  }

  int get totalAllCatches {
    int total = 0;
    availablePestTypes.forEach((pestType) {
      total += getTotalCatchesByPestType(pestType);
    });
    return total;
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