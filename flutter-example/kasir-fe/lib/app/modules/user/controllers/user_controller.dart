import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kasir/app/service/api_endpoint.dart';

class UserController extends GetxController {
  final box = GetStorage();

  var users = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.get(
        Uri.parse(ApiEndpoint.user),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List data = jsonResponse['data']; // pastikan struktur JSON begini

        users.assignAll(List<Map<String, dynamic>>.from(data));
      } else {
        Get.snackbar('Gagal', 'Gagal memuat data user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.post(
        Uri.parse(ApiEndpoint.user),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print("Create Status: ${response.statusCode}");
      print("Create Body: ${response.body}");

      if (response.statusCode == 201) {
        Get.snackbar('Berhasil', 'User berhasil ditambahkan');
        fetchUsers(); // refresh data
      } else {
        final error = json.decode(response.body);
        Get.snackbar('Gagal', error['message'] ?? 'Gagal menambahkan user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    required String role,
    String? password,
  }) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final body = {
        'name': name,
        'email': email,
        'role': role,
      };

      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await http.put(
        Uri.parse('${ApiEndpoint.user}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        fetchUsers();
        Get.snackbar('Sukses', 'User berhasil diperbarui');
      } else {
        Get.snackbar('Gagal', 'Gagal mengubah data user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(dynamic id) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await http.delete(
        Uri.parse('${ApiEndpoint.user}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Delete Status: ${response.statusCode}");
      print("Delete Body: ${response.body}");

      if (response.statusCode == 200) {
        fetchUsers();
        Get.snackbar('Sukses', 'User berhasil dihapus');
      } else {
        Get.snackbar('Gagal', 'Gagal menghapus user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
