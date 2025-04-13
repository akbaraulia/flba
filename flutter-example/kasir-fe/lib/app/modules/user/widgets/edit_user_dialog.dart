import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/user/controllers/user_controller.dart';

class EditUserModal extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserModal({super.key, required this.user});

  @override
  State<EditUserModal> createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final controller = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String selectedRole = 'kasir';
  bool obscurePassword = true;
  bool isPasswordEdited = false; // Tambahan untuk menandai apakah password diubah

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    emailController = TextEditingController(text: widget.user['email']);
    passwordController = TextEditingController();
    selectedRole = widget.user['role'] ?? 'kasir';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Hanya update password jika diisi/diubah
      final passwordToUpdate = isPasswordEdited ? passwordController.text : null;
      
      controller.updateUser(
        id: widget.user['id'].toString(),
        name: nameController.text,
        email: emailController.text,
        password: passwordToUpdate, // null akan diabaikan di controller
        role: selectedRole,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email wajib diisi' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Kosongkan jika tidak ingin mengubah',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (passwordController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              passwordController.clear();
                              isPasswordEdited = false;
                            });
                          },
                        ),
                      IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                obscureText: obscurePassword,
                onChanged: (value) {
                  setState(() {
                    isPasswordEdited = value.isNotEmpty;
                  });
                },
                validator: (value) {
                  if (isPasswordEdited && value!.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'kasir', child: Text('Kasir')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedRole = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}