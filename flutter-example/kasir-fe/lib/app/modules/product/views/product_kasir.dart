import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/product/controllers/product_controller.dart';

class ProductKasir extends StatelessWidget {
  ProductKasir({super.key});

  final controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Produk')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Nama Produk')),
                DataColumn(label: Text('Harga')),
                DataColumn(label: Text('Stok')),
              ],
              rows: List.generate(controller.products.length, (index) {
                final product = controller.products[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: controller.getImageWidget(product['img_url']),
                          ),
                          const SizedBox(width: 8),
                          Text(product['name_product']),
                        ],
                      ),
                    ),
                    DataCell(Text('Rp ${product['price']}')),
                    DataCell(Text('${product['stok']}')),
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
