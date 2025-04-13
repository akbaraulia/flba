import 'package:get/get.dart';
import 'package:kasir/app/modules/home/controllers/dashboard_controller.dart';

class BindingHome extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
