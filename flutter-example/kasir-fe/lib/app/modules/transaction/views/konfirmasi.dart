import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kasir/app/modules/transaction/controllers/transaction_controller.dart';

class Konfirmasi extends StatelessWidget {
  const Konfirmasi({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    final TextEditingController namaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Transaksi')),
      body: Obx(() {
        if (transactionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final total = transactionController.getTotalBayar();
        final bayar = transactionController.uangDiberi.value;
        final kembalian = bayar - total;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan data member jika ditemukan, jika tidak tampilkan form
              transactionController.memberData.value != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Nama Member: ${transactionController.memberData.value!['name']}'),
                        Text(
                            'Poin: ${transactionController.memberData.value!['point']}'),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Member tidak ditemukan'),
                        const SizedBox(height: 8),
                        // Form input nama member baru
                        TextField(
                          controller: namaController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Member Baru',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final namaMember = namaController.text.trim();
                            if (namaMember.isNotEmpty) {
                              await transactionController.createNewMember(
                                  nama: namaMember);
                              // Setelah membuat member baru, refresh data member
                              transactionController.fetchMember();
                            } else {
                              Get.snackbar('Error', 'Nama member harus diisi');
                            }
                          },
                          child: const Text('Buat Member Baru'),
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
              Text('Total Harga: Rp $total'),
              Text('Uang Diberi: Rp $bayar'),
              Text('Kembalian: Rp $kembalian'),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final box = GetStorage();
                  final userId = box.read('user_id');

                  if (userId == null || userId is! int) {
                    Get.snackbar(
                        'Error', 'User belum login atau ID tidak valid');
                    return;
                  }

                  final productIds = transactionController
                      .productQuantities.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => entry.key!)
                      .toList();

                  await transactionController.bayarMember(
                    userId: userId,
                    productIds: productIds,
                    total: total,
                    pay: bayar,
                  );

                  Get.toNamed('/result');
                },
                child: const Text('Selesaikan Transaksi'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
