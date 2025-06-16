import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../data/models/alat_model.dart';
import '../../../../data/services/alat_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class DetailDataController extends GetxController {
  var traps = <AlatModel>[].obs;
  var selectedMonth = 0.obs;

  // Store company data passed from CompanyCard
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
    // Get company data from arguments
    final arguments = Get.arguments;
    if (arguments != null) {
      companyId.value = arguments['id'] ?? 0;
      companyName.value = arguments['name'] ?? '';
      companyAddress.value = arguments['address'] ?? '';
      companyPhoneNumber.value = arguments['phoneNumber'] ?? '';
      companyEmail.value = arguments['email'] ?? '';
      companyImagePath.value = arguments['imagePath'] ?? '';
      companyCreatedAt.value = arguments['createdAt'] ?? '';
      companyUpdatedAt.value = arguments['updatedAt'] ?? '';
    }

    fetchData();
  }

  // Modified fetchData to filter by company ID
  Future<void> fetchData() async {
    try {
      if (companyId.value > 0) {
        // Fetch alat filtered by company ID
        traps.value = await AlatService.fetchAlatByCompany(companyId.value);
      } else {
        // Fallback to fetch all alat if no company ID
        traps.value = await AlatService.fetchAlat();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void changeDate(DateTime date) {
    // Implementasi perubahan tanggal
    print("Tanggal berubah ke: ${date.toString()}");
  }

  void updateNote(int index, String value) {}

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
    Get.offNamed('/bottomnav');
  }

  // Helper method to get company info
  String getCompanyInfo() {
    return "${companyName.value} - ${companyAddress.value}";
  }
}