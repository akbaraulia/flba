import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class DashboardKasirController extends GetxController {
  final box = GetStorage();
  var selectedIndex = 0.obs;
  var jumlahPembeli = 0.obs; // Menyimpan jumlah pembeli

  @override
  void onInit() {
    super.onInit();
    getJumlahPembeliHariIni(); // Ambil jumlah pembeli saat controller diinisialisasi
  }

  Future<void> getJumlahPembeliHariIni() async {
    try {
      String? token = GetStorage().read('token');

      // Pastikan token ada
      if (token == null) {
        print('Token tidak ditemukan!');
        return;
      }

      // Set header Authorization
      final response = await http.get(
        Uri.parse(
            'http://192.168.158.106:8000/api/dashboard/jumlah-pembeli-hari-ini'),
        headers: {
          'Authorization': 'Bearer $token', // Menambahkan header token
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        jumlahPembeli.value = data['jumlah_pembeli'];
      } else {
        // Log response error untuk debugging
        print('Gagal mengambil data jumlah pembeli: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Tangani error jika koneksi gagal atau terjadi masalah lainnya
      print('Error: $e');
    }
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    box.remove('token');
    box.remove('user');
    Get.offAllNamed('/login');
  }
}
