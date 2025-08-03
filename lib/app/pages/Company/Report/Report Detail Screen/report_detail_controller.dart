import 'package:get/get.dart';

class ReportDetailController extends GetxController {
  var area = ''.obs;
  var information = ''.obs;
  var documentation = ''.obs;

  void setArea(String value) {
    area.value = value;
  }

  void setInformation(String value) {
    information.value = value;
  }

  void setDocumentation(String value) {
    documentation.value = value;
  }
}
