import 'package:get/get.dart';

import 'detail_data_controller.dart';

class DetailDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailDataController>(() => DetailDataController());
  }
}
