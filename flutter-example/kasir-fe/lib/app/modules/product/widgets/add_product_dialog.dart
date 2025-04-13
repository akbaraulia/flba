import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductModal extends StatefulWidget {
  final Function(String name, String price, String stok, XFile? image) onSubmit;

  const AddProductModal({super.key, required this.onSubmit});

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stokController = TextEditingController();
  XFile? selectedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            const Text('Tambah Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: stokController,
              decoration: const InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            ),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedImage != null
                    ? Image.file(File(selectedImage!.path), fit: BoxFit.cover)
                    : const Center(child: Text('Pilih Gambar')),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(
                    nameController.text,
                    priceController.text,
                    stokController.text,
                    selectedImage,
                  );
                  Get.back();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
