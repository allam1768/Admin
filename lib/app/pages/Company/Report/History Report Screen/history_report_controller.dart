import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../data/models/report_model.dart';
import '../../../../../data/services/report_service.dart';

class HistoryReportController extends GetxController {
  final ReportService _reportService = ReportService();

  var reports = <ReportModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var isLoadingMore = false.obs;

  final String role = 'admin'; // langsung hardcode role

  @override
  void onInit() {
    super.onInit();
    checkTokenAndLoadReports();
  }

  Future<void> checkTokenAndLoadReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final companyId = prefs.getInt('companyid');
      final nama = prefs.getString('nama');

      print('🔍 === DEBUGGING USER DATA ===');
      print('🔑 Token exists: ${token != null}');
      print('🔑 Token length: ${token?.length ?? 0}');
      print('🏢 Company ID: $companyId');
      print('👤 Role: $role');
      print('📛 Nama: $nama');
      print('===============================');

      if (token == null || token.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'Please login to continue';
        Get.snackbar(
          'Authentication Error',
          'Please login to continue',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (companyId == null) {
        hasError.value = true;
        errorMessage.value = 'Company ID not found. Please re-login.';
        Get.snackbar(
          'Data Error',
          'Company ID not found. Please re-login.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      loadReports();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Authentication error: $e';
      print('❌ Error checking token: $e');
    }
  }

  Future<void> loadReports({bool refresh = false}) async {
    try {
      // Dapatkan company ID dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getInt('companyid');

      if (companyId == null) {
        hasError.value = true;
        errorMessage.value = 'Company ID not found. Please re-login.';
        return;
      }

      if (refresh) {
        currentPage.value = 1;
        reports.clear();
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Filter berdasarkan company_id
      final response = await _reportService.getReportsByCompany(
          companyId,
          page: currentPage.value
      );

      if (response.success) {
        final validReports = <ReportModel>[];

        for (final report in response.data.data) {
          try {
            // Pastikan report berasal dari company yang sama
            if (report.companyId == companyId) {
              // Validasi data yang diperlukan
              report.namaPengirim;
              report.area;
              report.informasi;
              report.role;
              report.formattedDate;
              report.formattedTime;

              validReports.add(report);
            } else {
              print('⚠️ Report ${report.id} filtered out - different company ID: ${report.companyId}');
            }
          } catch (e) {
            print('❌ Invalid report data: $e');
            continue;
          }
        }

        if (refresh) {
          reports.assignAll(validReports);
        } else {
          reports.addAll(validReports);
        }

        lastPage.value = response.data.lastPage;
        currentPage.value = response.data.currentPage;

        print('✅ Reports loaded successfully: ${reports.length} (Company ID: $companyId)');
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
        print('❌ API returned error: ${response.message}');
      }
    } catch (e, stackTrace) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('❌ Exception caught: $e');
      print('📍 Stack trace: $stackTrace');

      String userFriendlyMessage;
      if (e.toString().contains('No internet connection')) {
        userFriendlyMessage = 'No internet connection. Please check your network.';
      } else if (e.toString().contains('Unauthorized')) {
        userFriendlyMessage = 'Session expired. Please login again.';
      } else {
        userFriendlyMessage = 'Failed to load reports. Please try again.';
      }

      Get.snackbar('Error', userFriendlyMessage, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreReports() async {
    if (isLoadingMore.value || currentPage.value >= lastPage.value) return;

    try {
      // Dapatkan company ID dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getInt('companyid');

      if (companyId == null) {
        Get.snackbar('Error', 'Company ID not found', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      isLoadingMore.value = true;
      currentPage.value++;

      // Filter berdasarkan company_id
      final response = await _reportService.getReportsByCompany(
          companyId,
          page: currentPage.value
      );

      if (response.success) {
        // Filter report berdasarkan company ID untuk keamanan tambahan
        final filteredReports = response.data.data
            .where((report) => report.companyId == companyId)
            .toList();

        reports.addAll(filteredReports);
        print('✅ More reports loaded: ${filteredReports.length} (Company ID: $companyId)');
      } else {
        currentPage.value--;
        Get.snackbar('Error', 'Failed to load more reports', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      currentPage.value--;
      print('❌ Error loading more reports: $e');
      Get.snackbar('Error', 'Failed to load more reports', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshReports() async {
    await loadReports(refresh: true);
  }

  void retryLoadReports() {
    loadReports();
  }

  void addReport(ReportModel report) {
    // Validasi company ID sebelum menambahkan
    final prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      final companyId = prefs.getInt('companyid');
      if (companyId != null && report.companyId == companyId) {
        reports.insert(0, report);
      }
    });
  }

  void updateReport(ReportModel updatedReport) {
    // Validasi company ID sebelum update
    final prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      final companyId = prefs.getInt('companyid');
      if (companyId != null && updatedReport.companyId == companyId) {
        final index = reports.indexWhere((report) => report.id == updatedReport.id);
        if (index != -1) {
          reports[index] = updatedReport;
        }
      }
    });
  }

  void removeReport(int reportId) {
    reports.removeWhere((report) => report.id == reportId);
  }

  Map<String, List<ReportModel>> get groupedReports {
    try {
      final Map<String, List<ReportModel>> grouped = {};

      for (final report in reports) {
        final dateKey = report.formattedDate;
        grouped.putIfAbsent(dateKey, () => []).add(report);
      }

      final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

      return {
        for (var key in sortedKeys) key: grouped[key]!,
      };
    } catch (e) {
      print('❌ Error grouping reports: $e');
      return {};
    }
  }

  List<ReportModel> getReportsByRole(String inputRole) {
    try {
      return reports.where((report) => report.role == inputRole).toList();
    } catch (e) {
      print('❌ Error filtering by role: $e');
      return [];
    }
  }

  List<ReportModel> searchReports(String query) {
    if (query.isEmpty) return reports;

    try {
      final searchQuery = query.toLowerCase();
      return reports.where((report) {
        return report.namaPengirim.toLowerCase().contains(searchQuery) ||
            report.area.toLowerCase().contains(searchQuery) ||
            report.informasi.toLowerCase().contains(searchQuery);
      }).toList();
    } catch (e) {
      print('❌ Error searching reports: $e');
      return [];
    }
  }

  Future<void> debugUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('🐛 === USER SESSION DEBUG ===');
      print('Token: ${prefs.getString('token')}');
      print('Company ID: ${prefs.getInt('companyid')}');
      print('Name: ${prefs.getString('nama')}');
      print('Username: ${prefs.getString('username')}');
      print('Is Logged In: ${prefs.getBool('isLoggedIn')}');
      print('All Keys: ${prefs.getKeys()}');
      print('=============================');
    } catch (e) {
      print('❌ Error debugging session: $e');
    }
  }
}