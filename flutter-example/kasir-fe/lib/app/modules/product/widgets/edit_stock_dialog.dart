import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class EditStockModal extends StatefulWidget {
  final int productId;
  final String initialStock;
  final VoidCallback onStockUpdated;

  const EditStockModal({
    super.key,
    required this.productId,
    required this.initialStock,
    required this.onStockUpdated,
  });

  @override
  State<EditStockModal> createState() => _EditStockModalState();
}

class _EditStockModalState extends State<EditStockModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController stockController;
  final controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    stockController = TextEditingController(text: widget.initialStock);
  }

  @override
  void dispose() {
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            const Center(
              child: Text(
                'Edit Stok Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Stok',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Stok wajib diisi';
                if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                return null;
              },
            ),
            ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await controller.updateStock(
                    id: widget.productId,
                    stock: stockController.text,
                  );
                  widget.onStockUpdated();
                  Get.back();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan Stok'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
