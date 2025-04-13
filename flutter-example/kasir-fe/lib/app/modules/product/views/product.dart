import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/product/controllers/product_controller.dart';
import 'package:kasir/app/modules/product/widgets/add_product_dialog.dart';
import 'package:kasir/app/modules/product/widgets/edit_procut_diaolog.dart';
import 'package:kasir/app/modules/product/widgets/edit_stock_dialog.dart';

class Product extends StatelessWidget {
  Product({super.key});

  final controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Produk')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) {
                      return AddProductModal(
                        onSubmit: (name, price, stok, image) {
                          controller.createProduct(
                            name: name,
                            price: price,
                            stok: stok,
                            imagePath: image?.path ?? '',
                          );
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Nama Produk')),
                      DataColumn(label: Text('Harga')),
                      DataColumn(label: Text('Stok')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: List.generate(controller.products.length, (index) {
                      final product = controller.products[index];
                      print('IMG URL: ${product['img_url']}');
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: controller
                                      .getImageWidget(product['img_url']),
                                ),
                                const SizedBox(width: 8),
                                Text(product['name_product']),
                              ],
                            ),
                          ),
                          DataCell(Text('Rp ${product['price']}')),
                          DataCell(Text('${product['stok']}')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (_) {
                                      return EditProductModal(
                                        product: product,
                                        onSubmit: (name, price, image) {
                                          controller.updateProduct(
                                            id: product['id'],
                                            name: name,
                                            price: price,
                                            imagePath: image?.path ?? '',
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit Produk',
                                color: Colors.amber,
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (_) {
                                      return EditStockModal(
                                        productId:
                                            int.parse(product['id'].toString()),
                                        initialStock:
                                            product['stok'].toString(),
                                        onStockUpdated:
                                            controller.fetchProducts,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.inventory),
                                tooltip: 'Edit Stok',
                                color: Colors.green,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                          'Apakah kamu yakin ingin menghapus produk ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await controller
                                                .deleteProduct(product['id']);
                                          },
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete),
                                tooltip: 'Hapus Produk',
                                color: Colors.red,
                              ),
                            ],
                          )),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
