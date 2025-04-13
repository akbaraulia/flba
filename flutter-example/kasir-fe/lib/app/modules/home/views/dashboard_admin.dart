import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/home/controllers/dashboard_controller.dart';
import 'package:kasir/app/modules/home/widgets/barchart.dart';
import 'package:kasir/app/modules/home/widgets/diagrampie.dart';
import 'package:kasir/app/modules/product/views/product.dart';
import 'package:kasir/app/modules/user/views/user.dart';

class DashboardAdmin extends StatelessWidget {
  DashboardAdmin({super.key});

  final DashboardController controller = Get.put(DashboardController());

  final List<Widget> _pages = [
    DashboardContent(),
    Product(),
    const Center(child: Text("Pembelian")),
    User()
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.logout();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Kasir Mantap", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: _pages,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(0.5),
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          const Text(
            'Penjualan 15 Hari Terakhir',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 200, child: Barchart()),
          const SizedBox(height: 20),
          const Text(
            'Persentase Penjualan Produk',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
           SizedBox(height: 200, child: Diagrampie()),
        ],
      ),
    );
  }
}