import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/history/controllers/history_controller.dart';

class History extends StatelessWidget {
  History({super.key});
  final controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.groupedPayments.length,
          itemBuilder: (_, index) {
            final group = controller.groupedPayments[index];
            final products = group['items'];

            return Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal: ${group['created_at']}'),
                    Text('Total: Rp ${group['total_price']}'),
                    Text('Bayar: Rp ${group['pay']}'),
                    Text('Kembali: Rp ${group['change']}'),
                    const SizedBox(height: 8),
                    const Text('Produk:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...products.map<Widget>((p) {
                      print(p); // Tambahkan ini untuk cek isi p
                      final product = p['product'];
                      final qty = p['qty']; // Pastikan ambil dari sini

                      final productName = product != null
                          ? product['name_product']
                          : '[Produk tidak ditemukan]';

                      return Text('$productName x$qty');
                    }).toList(),
                    ElevatedButton.icon(
                      onPressed: () => controller.generatePDF(group),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Unduh PDF'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
