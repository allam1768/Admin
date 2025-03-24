import 'package:get/get.dart';

class DataCompanyController extends GetxController {
  // Data perusahaan dalam bentuk RxList agar bisa di-update secara real-time
  final companies = <Map<String, String>>[
    {"name": "Indofood", "image": "assets/images/example.png"},
    {"name": "Unilever", "image": "assets/images/example.png"},
    {"name": "Nestle", "image": "assets/images/example.png"},
  ].obs;
}
