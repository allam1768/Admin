import 'package:get/get.dart';
import 'history_report_controller.dart';

class HistoryReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryReportController>(() => HistoryReportController());
  }
}
