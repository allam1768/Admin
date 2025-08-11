import 'package:get/get.dart';
import '../../../../data/models/client_model.dart';
import '../../../../data/services/client_service.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class AccountClientController extends GetxController {
  // Observable variables for client data
  final clientData = Rxn<ClientModel>();
  final isLoading = false.obs;

  // User display data
  final userName = "".obs;
  final userEmail = "".obs;
  final fullName = "".obs;
  final company = "".obs;
  final phoneNumber = "".obs;
  final password = "password123".obs;
  final profileImage = "".obs;
  final clientId = "".obs;
  final createdAt = "".obs;

  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    final String? clientName = Get.arguments;
    if (clientName != null) {
      fetchClientData(clientName);
    }
  }

  /// Konversi waktu UTC ke WIB (UTC+7)
  String convertUtcToWib(String utcTimeString) {
    try {
      // Parse UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Konversi ke WIB (UTC+7)
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      // Format ke string yang diinginkan
      return "${wibTime.day.toString().padLeft(2, '0')}/${wibTime.month.toString().padLeft(2, '0')}/${wibTime.year}";
    } catch (e) {
      print("Error converting UTC to WIB: $e");
      return utcTimeString; // Return original string jika error
    }
  }

  /// Konversi waktu UTC ke WIB dengan format lengkap (termasuk jam, menit, detik)
  String convertUtcToWibFull(String utcTimeString) {
    try {
      // Parse UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Konversi ke WIB (UTC+7)
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      // Format lengkap: DD/MM/YYYY HH:mm:ss WIB
      return "${wibTime.day.toString().padLeft(2, '0')}/${wibTime.month.toString().padLeft(2, '0')}/${wibTime.year} "
          "${wibTime.hour.toString().padLeft(2, '0')}:${wibTime.minute.toString().padLeft(2, '0')}:${wibTime.second.toString().padLeft(2, '0')} WIB";
    } catch (e) {
      print("Error converting UTC to WIB: $e");
      return utcTimeString; // Return original string jika error
    }
  }

  /// Konversi waktu UTC ke WIB dengan format custom
  String convertUtcToWibCustom(String utcTimeString, {bool includeTime = false, bool includeWibSuffix = true}) {
    try {
      // Parse UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Konversi ke WIB (UTC+7)
      DateTime wibTime = utcTime.add(Duration(hours: 7));

      String dateString = "${wibTime.day.toString().padLeft(2, '0')}/${wibTime.month.toString().padLeft(2, '0')}/${wibTime.year}";

      if (includeTime) {
        String timeString = "${wibTime.hour.toString().padLeft(2, '0')}:${wibTime.minute.toString().padLeft(2, '0')}";
        dateString += " $timeString";

        if (includeWibSuffix) {
          dateString += " WIB";
        }
      }

      return dateString;
    } catch (e) {
      print("Error converting UTC to WIB: $e");
      return utcTimeString; // Return original string jika error
    }
  }

  Future<void> fetchClientData(String clientName) async {
    try {
      isLoading.value = true;
      final clients = await ClientService.fetchClients();

      // Find client by name
      final client = clients.firstWhereOrNull((c) => c.name == clientName);

      if (client != null) {
        clientData.value = client;

        // Update observable variables with actual data
        userName.value = client.name;
        fullName.value = client.name;
        company.value = client.company ?? "-";
        clientId.value = client.id.toString();
        userEmail.value = client.email ?? "Email tidak tersedia";
        phoneNumber.value = client.phoneNumber ?? "Phone tidak tersedia";

        // Format created date dengan konversi UTC ke WIB
        if (client.createdAt != null) {
          try {
            // Gunakan fungsi konversi UTC ke WIB
            createdAt.value = convertUtcToWib(client.createdAt!);
          } catch (e) {
            createdAt.value = client.createdAt ?? "Data tidak tersedia";
          }
        } else {
          createdAt.value = "Data tidak tersedia";
        }

        // Set profile image
        if (client.image != null && client.image!.isNotEmpty) {
          if (client.image!.startsWith('http')) {
            profileImage.value = client.image!;
          } else {
            profileImage.value = 'https://hamatech.rplrus.com/storage/${client.image}';
          }
        } else {
          profileImage.value = "assets/images/example.png";
        }

        // Try to fetch more detailed data if available
        final detailData = await ClientService.fetchClientDetail(client.id);
        if (detailData != null) {
          userEmail.value = detailData.email ?? userEmail.value;
          phoneNumber.value = detailData.phoneNumber ?? phoneNumber.value;
          company.value = detailData.company ?? company.value;

          if (detailData.createdAt != null) {
            try {
              // Gunakan fungsi konversi UTC ke WIB untuk detail data
              createdAt.value = convertUtcToWib(detailData.createdAt!);
            } catch (e) {
              createdAt.value = detailData.createdAt ?? createdAt.value;
            }
          }
        }
      } else {
        Get.snackbar("Error", "Client tidak ditemukan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data client: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // FIXED: Pass both client object and clientId in a map
  void goToEditAccount() {
    if (clientData.value != null) {
      Get.toNamed('/EditAccountClient', arguments: {
        'client': clientData.value,
        'clientId': clientData.value!.id,
      });
    } else {
      Get.snackbar("Error", "Data client tidak tersedia");
    }
  }

  void deleteAccount() async {
    try {
      if (clientData.value != null) {
        isLoading.value = true;
        await ClientService.deleteClient(clientData.value!.id);
        Get.snackbar("Success", "Client berhasil dihapus");

        // Navigate back to client list
        Get.find<BottomNavController>().selectedIndex.value = 1;
        Get.offNamed('/bottomnav');
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus client: $e");
    } finally {
      isLoading.value = false;
    }
  }
}