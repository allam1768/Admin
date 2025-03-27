import 'package:get/get.dart';

class DataWorkerController extends GetxController {
  final worker = <Map<String, String>>[
    {"nokaryawan": "123213", "nama": "Wawan", "imagePath": "assets/images/example.png"},
    {"nokaryawan": "12654", "nama": "Doni", "imagePath": "assets/images/example.png"},
    {"nokaryawan": "42352", "nama": "Rina", "imagePath": "assets/images/example.png"},
  ].obs;

  void goToCreateAccountWorker() {
    Get.toNamed('/CreateAccountWorker');
  }
}
