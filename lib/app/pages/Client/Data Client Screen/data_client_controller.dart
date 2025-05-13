import 'package:get/get.dart';
import '../../../../data/models/client_model.dart';
import '../../../../data/services/client_service.dart';


class DataClientController extends GetxController {
  final clients = <ClientModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      isLoading.value = true;
      final data = await ClientService.fetchClients();
      clients.value = data;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToCreateClient() {
    Get.toNamed('/CreateAccountClient');
  }
}
