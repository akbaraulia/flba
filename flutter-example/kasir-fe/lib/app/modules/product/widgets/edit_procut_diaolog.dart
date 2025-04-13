import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/product_controller.dart';

class EditProductModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(String name, String price, XFile? image) onSubmit;

  const EditProductModal({
    super.key,
    required this.product,
    required this.onSubmit,
  });

  @override
  State<EditProductModal> createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  XFile? _pickedImage;

  final controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name_product']);
    priceController = TextEditingController(text: widget.product['price'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final image = await controller.pickImage();
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
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
              child: Text('Edit Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Harga wajib diisi' : null,
            ),
            TextFormField(
              enabled: false,
              initialValue: widget.product['stok'].toString(),
              decoration: const InputDecoration(labelText: 'Stok (ubah dari modal lain)'),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: _pickedImage != null
                  ? Image.file(File(_pickedImage!.path), height: 100)
                  : controller.getImageWidget(widget.product['img_url'], height: 100),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(
                    nameController.text,
                    priceController.text,
                    _pickedImage,
                  );
                  Get.back();
                }
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
