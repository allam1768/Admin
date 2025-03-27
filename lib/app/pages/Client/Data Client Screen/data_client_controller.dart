import 'package:get/get.dart';

class DataClientController extends GetxController {
  final clients = <Map<String, String>>[
    {"company": "Indofood", "client": "Wawan", "imagePath": "assets/images/example.png"},
    {"company": "Unilever", "client": "Doni", "imagePath": "assets/images/example.png"},
    {"company": "Nestle", "client": "Rina", "imagePath": "assets/images/example.png"},
  ].obs;

  void goToCreateClient() {
    Get.toNamed('/CreateAccountClient');
  }
}
