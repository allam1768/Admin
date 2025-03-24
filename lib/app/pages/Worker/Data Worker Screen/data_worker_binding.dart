import 'package:admin/app/pages/Client/Data%20Client%20Screen/data_client_controller.dart';
import 'package:get/get.dart';

import 'data_worker_controller.dart';

class DataWorkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataWorkerController>(() => DataWorkerController());
  }
}
