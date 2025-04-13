import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kasir/app/modules/product/controllers/product_controller.dart';
import 'package:kasir/app/modules/transaction/controllers/transaction_controller.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final transactionController = Get.find<TransactionController>();
  final productController = Get.find<ProductController>();
  final TextEditingController namaController = TextEditingController();

  final TextEditingController uangController = TextEditingController();
  String buyerType = 'non-member';
  final TextEditingController telpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final products = productController.products
        .where(
            (p) => (transactionController.productQuantities[p['id']] ?? 0) > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index];
                  final qty =
                      transactionController.productQuantities[product['id']]!;
                  final subtotal = transactionController.getSubtotal(product);

                  return ListTile(
                    title: Text(product['name_product']),
                    subtitle: Text('Qty: $qty • Subtotal: Rp $subtotal'),
                    trailing: Text('Rp ${product['price']}'),
                  );
                },
              ),
            ),
            const Divider(),
            Obx(() {
              final total = transactionController.getTotalBayar();
              final totalItems = products.fold<int>(
                0,
                (sum, p) =>
                    sum +
                    (transactionController.productQuantities[p['id']] ?? 0),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Barang: $totalItems'),
                  Text('Total Harga: Rp $total'),
                ],
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Member'),
                    value: 'member',
                    groupValue: buyerType,
                    onChanged: (val) => setState(() => buyerType = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Non-Member'),
                    value: 'non-member',
                    groupValue: buyerType,
                    onChanged: (val) => setState(() => buyerType = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: uangController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Uang dari pelanggan',
                border: OutlineInputBorder(),
              ),
            ),
            if (buyerType == 'member') ...[
              const SizedBox(height: 16),
              TextField(
                controller: telpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon Member',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final box = GetStorage();
                  final userId = box.read('user_id');
                  final uang = int.tryParse(uangController.text);

                  if (userId == null || userId is! int) {
                    Get.snackbar(
                        'Error', 'User belum login atau ID tidak valid');
                    return;
                  }

                  if (uang == null) {
                    Get.snackbar('Error', 'Masukkan nominal uang yang valid');
                    return;
                  }

                  transactionController.uangDiberi.value = uang;

                  if (buyerType == 'non-member') {
                    final total = transactionController.getTotalBayar();
                    final productIds = transactionController
                        .productQuantities.entries
                        .where((entry) =>
                            entry.key != null &&
                            entry.value != null &&
                            entry.value > 0)
                        .map((entry) => entry.key!)
                        .toList();

                    await transactionController.bayarNonMember(
                      userId: userId,
                      productIds: productIds,
                      total: total,
                      pay: uang,
                    );

                    Get.toNamed('/result');
                  } else {
                    // Handle member
                    transactionController.nomorTeleponMember.value =
                        telpController.text;

                    // Validate the member and create new member if necessary
                    await transactionController.fetchMember();

                    if (transactionController.memberData.value == null) {
                      // Tampilkan dialog untuk isi nama member baru
                      await showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Member Tidak Ditemukan'),
                          content: TextField(
                            controller: namaController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Member Baru',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final nama = namaController.text.trim();
                                if (nama.isNotEmpty) {
                                  await transactionController.createNewMember(
                                      nama: nama);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(ctx).pop();
                                  Get.toNamed('/konfirmasi');
                                } else {
                                  Get.snackbar(
                                      'Error', 'Nama tidak boleh kosong');
                                }
                              },
                              child: const Text('Buat Member'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Get.toNamed('/konfirmasi');
                    }

                    Get.toNamed('/konfirmasi');
                  }
                },
                child: const Text('Konfirmasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
