import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
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
  // data penjualan per hari
  // final List<Map<String, dynamic>> salesData = List.generate(20, (index) {
  //   return {
  //     "day": index + 1,
  //     "sales": (index * 2) % 45,
  //   };
  // });

  // data penjualan barang
  // final List<Map<String, dynamic>> categorySales = [
  //   {"category": "Makanan", "percentage": 40},
  //   {"category": "Minuman", "percentage": 30},
  //   {"category": "Lainnya", "percentage": 30},
  // ];
}
