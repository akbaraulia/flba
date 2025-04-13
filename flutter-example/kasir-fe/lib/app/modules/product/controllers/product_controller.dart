import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kasir/app/service/api_endpoint.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
  final box = GetStorage();

  var isLoading = true.obs;
  var products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final token = box.read('token');
      print("Token yang digunakan: $token");

      final response = await http.get(
        Uri.parse(ApiEndpoint.product),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

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

  Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> createProduct({
    required String name,
    required String price,
    required String stok,
    required String imagePath,
  }) async {
    try {
      final token = box.read('token');
      final url = Uri.parse(ApiEndpoint.product);

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name_product'] = name;
      request.fields['price'] = price;
      request.fields['stok'] = stok;

      request.files.add(await http.MultipartFile.fromPath('img', imagePath));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Berhasil', 'Produk berhasil ditambahkan');
        fetchProducts();
      } else {
        Get.snackbar('Gagal', 'Gagal menambah produk');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Image getImageWidget(String? imageUrl,
      {double width = 40, double height = 40}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png', // optional: gambar default
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
    );
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required String price,
    required String imagePath,
  }) async {
    try {
      final token = box.read('token');
      final url = Uri.parse('${ApiEndpoint.product}/$id');

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'PUT';
      request.fields['name_product'] = name;
      request.fields['price'] = price;

      if (imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('img', imagePath));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Produk berhasil diperbarui');
        fetchProducts();
      } else {
        Get.snackbar('Gagal', 'Gagal memperbarui produk');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> updateStock({
    required int id,
    required String stock,
  }) async {
    try {
      final token = box.read('token');
      final url = Uri.parse('${ApiEndpoint.product}/$id');

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'PUT';
      request.fields['stok'] = stock;

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Stok berhasil diperbarui');
      } else {
        Get.snackbar('Gagal', 'Gagal memperbarui stok');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final token = box.read('token');
      final url = Uri.parse('${ApiEndpoint.product}/$id');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Produk berhasil dihapus');
        fetchProducts(); // refresh data
      } else {
        Get.snackbar('Gagal', 'Gagal menghapus produk');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
