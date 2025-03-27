import 'package:get/get.dart';

class DataCompanyController extends GetxController {
  var companies = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  void fetchCompanies() {
    companies.value = [
      {"name": "Company A", "image": "assets/images/example.png"},
      {"name": "Company B", "image": "assets/images/example.png"},
    ];
  }

  int get companyCount => companies.length;

  Map<String, String> getCompany(int index) => companies[index];
}
