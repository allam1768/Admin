import 'package:get/get.dart';
import '../../../../data/models/worker_model.dart';
import '../../../../data/services/worker_service.dart';

class DataWorkerController extends GetxController {
  final workers = <WorkerModel>[].obs;
  final isLoading = false.obs;
  final WorkerService _workerService = WorkerService();

  @override
  void onInit() {
    super.onInit();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    try {
      isLoading.value = true;

      // Simulasi delay untuk melihat skeleton loading (opsional, bisa dihapus)
      await Future.delayed(const Duration(milliseconds: 500));

      final workersList = await _workerService.getWorkers();
      workers.assignAll(workersList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data worker: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToCreateAccountWorker() {
    Get.toNamed('/CreateAccountWorker');
  }
}