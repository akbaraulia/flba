import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/product/controllers/product_controller.dart';
import 'package:kasir/app/modules/transaction/controllers/transaction_controller.dart';

class Transaction extends StatelessWidget {
  Transaction({super.key});

  final productController = Get.put(ProductController());
  final transactionController = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Baru')),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Gambar produk
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: productController.getImageWidget(
                      product['img_url'],
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Informasi produk + tombol
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Obx(() {
                        final qty = transactionController
                                .productQuantities[product['id']] ??
                            0;
                        final subtotal =
                            transactionController.getSubtotal(product);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name_product'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue),
                            ),
                            const SizedBox(height: 4),
                            Text("Stok: ${product['stok']}"),
                            const SizedBox(height: 4),
                            Text("Rp ${product['price']}"),
                            const SizedBox(height: 8),

                            // Tombol + - dan jumlah
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => transactionController
                                      .decreaseQty(product['id']),
                                  icon: const Icon(Icons.remove),
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                  ),
                                  child: Text('$qty'),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => transactionController
                                      .increaseQty(product['id']),
                                  icon: const Icon(Icons.add),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: 'Sub Total: ',
                                children: [
                                  TextSpan(
                                    text: 'Rp ${subtotal.toString()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/checkout');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
