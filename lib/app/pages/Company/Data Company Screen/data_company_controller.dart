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
  void onReady() {
    super.onReady();
    // Pastikan data fresh ketika controller ready
    ever(companies, (_) => update());
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

      // Simulasi delay untuk melihat skeleton loading (opsional, bisa dihapus)
      await Future.delayed(const Duration(milliseconds: 500));

      final companiesList = await _companyService.getCompanies();

      // Update companies list
      companies.assignAll(companiesList);

      print('✅ Companies fetched successfully. Count: ${companies.length}');

    } catch (e) {
      // Snackbar dihapus, bisa log error jika mau
      print('❌ Gagal mengambil data perusahaan: $e');

      // Kosongkan list jika error
      companies.clear();

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOnScroll() async {
    try {
      isLoadingMore.value = true;

      // Simulasi delay untuk melihat skeleton loading (opsional, bisa dihapus)
      await Future.delayed(const Duration(milliseconds: 300));

      final companiesList = await _companyService.getCompanies();
      companies.assignAll(companiesList);

      print('✅ Companies refreshed on scroll. Count: ${companies.length}');

    } catch (e) {
      print('❌ Error refreshing companies on scroll: $e');
      Get.snackbar(
        'Error',
        'Gagal memperbarui data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Method untuk force refresh dari luar (misal setelah delete)
  Future<void> forceRefresh() async {
    print('🔄 Force refreshing companies...');
    await fetchCompanies();
  }

  /// Method untuk menghapus company dari list lokal
  void removeCompanyFromList(int companyId) {
    companies.removeWhere((company) => company.id == companyId);
    companies.refresh(); // Trigger UI update
    print('✅ Company with ID $companyId removed from local list');
  }

  /// Method untuk mengecek apakah company masih ada
  bool isCompanyExist(int companyId) {
    return companies.any((company) => company.id == companyId);
  }

  int get companyCount => companies.length;

  CompanyModel getCompany(int index) => companies[index];

  /// Method untuk mendapatkan company berdasarkan ID
  CompanyModel? getCompanyById(int companyId) {
    try {
      return companies.firstWhere((company) => company.id == companyId);
    } catch (e) {
      print('❌ Company with ID $companyId not found');
      return null;
    }
  }
}