import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/product/controllers/product_controller.dart';
import 'package:kasir/app/modules/transaction/controllers/transaction_controller.dart';

class Result extends StatelessWidget {
  Result({super.key});

  final productController = Get.find<ProductController>();
  final transactionController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    final selectedProducts = productController.products
        .where(
            (p) => (transactionController.productQuantities[p['id']] ?? 0) > 0)
        .toList();

    final total = transactionController.getTotalBayar();
    final uangDiberi = transactionController.uangDiberi.value;
    final kembalian = uangDiberi - total;

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: selectedProducts.length,
                itemBuilder: (_, index) {
                  final product = selectedProducts[index];
                  final qty =
                      transactionController.productQuantities[product['id']] ??
                          0;
                  final subtotal = transactionController.getSubtotal(product);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(product['name_product']),
                    subtitle: Text('Qty: $qty x Rp ${product['price']}'),
                    trailing: Text('Rp $subtotal'),
                  );
                },
              ),
            ),
            const Divider(),
            Text('Total: Rp $total'),
            Text('Uang Diberi: Rp $uangDiberi'),
            Text('Kembalian: Rp $kembalian'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await transactionController.generateAndDownloadInvoice();
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Unduh'),
                ),
                ElevatedButton(
                  onPressed: () {
                    transactionController.productQuantities.clear();
                    transactionController.uangDiberi.value = 0;
                    Get.offAllNamed('/transaction');
                  },
                  child: const Text('Selesai'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
