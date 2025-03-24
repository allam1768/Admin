import 'package:get/get.dart';
import 'detail_controller.dart';

class DetailHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailHistoryController>(() => DetailHistoryController());
  }
}
