import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/user/controllers/user_controller.dart';
import 'package:kasir/app/modules/user/widgets/add_user_dialog.dart';
import 'package:kasir/app/modules/user/widgets/edit_user_dialog.dart';

class User extends StatelessWidget {
  User({super.key});

  final controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen User')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) {
                      return AddUserModal(
                        onSubmit: (name, email, password, role) {
                          controller.createUser(
                            name: name,
                            email: email,
                            password: password,
                            role: role,
                          );
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah User'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: List.generate(controller.users.length, (index) {
                      final user = controller.users[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(user['name'] ?? '')),
                          DataCell(Text(user['email'] ?? '')),
                          DataCell(Text(user['role'] ?? '')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.amber),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (context) {
                                      return EditUserModal(user: user);
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                          'Apakah kamu yakin ingin menghapus user ini?'),
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
                                                .deleteUser(user['id']);
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
                                tooltip: 'Hapus user',
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
