import 'package:get/get.dart';
import '../../../../data/models/company_model.dart';
import '../../../../data/services/company_service.dart';

class DataCompanyController extends GetxController {
  final companies = <CompanyModel>[].obs;
  final isLoading = true.obs;
  final CompanyService _companyService = CompanyService();

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading.value = true;
      final companiesList = await _companyService.getCompanies();
      companies.assignAll(companiesList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data perusahaan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int get companyCount => companies.length;

  CompanyModel getCompany(int index) => companies[index];

}
