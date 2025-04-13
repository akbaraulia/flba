import 'package:get/get.dart';
import 'package:kasir/app/modules/history/controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override

  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
