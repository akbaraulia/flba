import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardKasirController extends GetxController {
  final box = GetStorage();
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    box.remove('token');
    box.remove('user');
    Get.offAllNamed('/login');
  }
}
