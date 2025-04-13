import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  final box = GetStorage();
  var selectedIndex = 0.obs;

  var penjualanData = [].obs;
  var persentaseProduk = [].obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    box.remove('token');
    box.remove('user');
    Get.offAllNamed('/login');
  }

  Future<void> getPenjualan15HariTerakhir() async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('http://192.168.158.106:8000/api/dashboard/penjualan-15-hari-terakhir'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['penjualan_15_hari'];
      penjualanData.value = data;
    } else {
      print('Gagal mengambil data penjualan 15 hari terakhir cihuy');
    }
  }

  Future<void> getPersentasePenjualanProduk() async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse(
          'http://192.168.158.106:8000/api/dashboard/persentase-penjualan-produk'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['penjualan_produk'];
      persentaseProduk.value = data;
    } else {
      print('Gagal mengambil data persentase penjualan produk');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPenjualan15HariTerakhir();
    getPersentasePenjualanProduk();
  }
}
