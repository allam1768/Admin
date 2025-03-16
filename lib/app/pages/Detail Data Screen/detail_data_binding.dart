import 'package:admin/app/pages/Detail%20Data%20Screen/detail_data_controller.dart';
import 'package:get/get.dart';

class DetailDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailDataController>(() => DetailDataController());
  }
}
