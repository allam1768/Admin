import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/company_model.dart';
import '../../../../data/services/company_service.dart';

class DataCompanyController extends GetxController {
  final companies = <CompanyModel>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final CompanyService _companyService = CompanyService();

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchCompanies();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      // Trigger refresh when near bottom (200px before end)
      if (!isLoadingMore.value && !isLoading.value) {
        refreshOnScroll();
      }
    }
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading.value = true;
      final companiesList = await _companyService.getCompanies();
      companies.assignAll(companiesList);
    } catch (e) {
      // Snackbar dihapus, bisa log error jika mau
      print('Gagal mengambil data perusahaan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOnScroll() async {
    try {
      isLoadingMore.value = true;
      final companiesList = await _companyService.getCompanies();
      companies.assignAll(companiesList);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  int get companyCount => companies.length;

  CompanyModel getCompany(int index) => companies[index];
}