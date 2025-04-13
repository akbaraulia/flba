import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kasir/app/service/api_endpoint.dart';

class TransactionController extends GetxController {
  final box = GetStorage();

  var productQuantities = <int, int>{}.obs;
  var uangDiberi = 0.obs;
  var nomorTeleponMember = ''.obs;
  var memberId = 0;
  var isLoading = true.obs;
  var products = <Map<String, dynamic>>[].obs;
  var memberData = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void increaseQty(int id) {
    productQuantities[id] = (productQuantities[id] ?? 0) + 1;
  }

  void decreaseQty(int id) {
    if ((productQuantities[id] ?? 0) > 0) {
      productQuantities[id] = productQuantities[id]! - 1;
    }
  }

  int getSubtotal(Map<String, dynamic> product) {
    int qty = productQuantities[product['id']] ?? 0;
    int price = int.tryParse(product['price'].toString()) ?? 0;
    return qty * price;
  }

  int getTotalBayar() {
    int total = 0;
    for (var product in products) {
      total += getSubtotal(product);
    }
    return total;
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final token = box.read('token');
      final response = await http.get(
        Uri.parse(ApiEndpoint.product),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        products.assignAll(List<Map<String, dynamic>>.from(data));
      } else {
        Get.snackbar(
            'Gagal', 'Gagal mengambil data produk: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Member Data
  Future<void> fetchMember() async {
    final phoneNumber = nomorTeleponMember.value;
    final token = box.read('token');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.158.106:8000/api/members/find'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'phone_number': phoneNumber}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['name'] != null) {
          memberData.value = data;
        } else {
          memberData.value = null;
        }
      } else {
        memberData.value = null;
      }
    } catch (e) {
      memberData.value = null;
    }
  }

  // Create New Member if needed
  Future<void> createNewMember({required String nama}) async {
    final box = GetStorage();
    final token = box.read('token');

    try {
      final url = Uri.parse('http://192.168.158.106:8000/api/members');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nama,
          'phone_number': nomorTeleponMember.value,
          'point': 0, // Poin bisa diatur sesuai kebutuhan
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final newMember = jsonDecode(response.body);
        memberData.value = newMember; // Simpan data member yang baru dibuat
        print('🆕 Member baru berhasil dibuat: ${newMember['name']}');
      } else {
        Get.snackbar('Error', 'Gagal membuat member baru: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  // Process Payment for Member
  Future<void> bayarMember({
    required int userId,
    required List<int> productIds,
    required int total,
    required int pay,
    int totalQty = 0,
  }) async {
    final token = box.read('token');
    try {
      final url = Uri.parse(ApiEndpoint.payment);
      for (var productId in productIds) {
        int qty = productQuantities[productId] ?? 0;
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "product_id": productId,
            "user_id": userId,
            "member_id": memberData.value?['id'],
            "total_price": total,
            "pay": pay,
            "change": pay - total,
            "qty": qty,
          }),
        );
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception("Gagal kirim transaksi untuk produk ID $productId");
        }
      }
      for (var productId in productIds) {
        int qty = productQuantities[productId] ?? 0;
        totalQty += qty;

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "product_id": productId,
            "user_id": userId,
            "member_id": memberData.value?['id'],
            "total_price": total,
            "pay": pay,
            "change": pay - total,
            "qty": qty,
          }),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception("Gagal kirim transaksi untuk produk ID $productId");
        }
      }
      await tambahPoinMember(totalQty);
      await fetchProducts();
    } catch (e) {
      Get.snackbar("Error", "Gagal melakukan transaksi: $e");
    }
  }

  // Process Payment for Non-Member
  Future<void> bayarNonMember({
    required int userId,
    required List<int> productIds,
    required int total,
    required int pay,
  }) async {
    final token = box.read('token');
    try {
      final url = Uri.parse(ApiEndpoint.payment);

      for (var productId in productIds) {
        int qty = productQuantities[productId] ?? 0;

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "product_id": productId,
            "user_id": userId,
            "member_id": null,
            "total_price": total,
            "pay": pay,
            "change": pay - total,
            "qty": qty, // kirim jumlah produk dibeli
          }),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception("Gagal kirim transaksi untuk produk ID $productId");
        }
      }

      await fetchProducts();
    } catch (e) {
      Get.snackbar("Error", "Gagal melakukan transaksi: $e");
    }
  }

  Future<void> tambahPoinMember(int poinBaru) async {
    final token = box.read('token');
    final member = memberData.value;

    if (member == null) return;

    final memberId = member['id'];
    final currentPoint = member['point'] ?? 0;

    try {
      final url =
          Uri.parse('http://192.168.158.106:8000/api/members/$memberId');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': member['name'],
          'phone_number': member['phone_number'],
          'point': currentPoint + poinBaru,
        }),
      );

      if (response.statusCode == 200) {
        final updatedData = jsonDecode(response.body);
        memberData.value = updatedData;
        print('✅ Poin member ditambahkan');
      } else {
        Get.snackbar('Error', 'Gagal menambah poin: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
