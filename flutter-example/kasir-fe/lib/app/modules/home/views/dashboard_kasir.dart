import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/history/views/history.dart';
import 'package:kasir/app/modules/home/controllers/dashboard_kasir_controller.dart';
import 'package:kasir/app/modules/product/views/product_kasir.dart';
import 'package:kasir/app/modules/transaction/views/transaction.dart';

class DashboardKasir extends StatelessWidget {
  DashboardKasir({super.key});

  final DashboardKasirController controller =
      Get.put(DashboardKasirController());

  final List<Widget> _pages = [
    KasirHomeContent(),
    ProductKasir(),
    Transaction(),
    History()
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Kasir",
            style: TextStyle(color: Colors.black)),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: "Produk",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: "Transaksi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history_toggle_off),
              label: "Histori",
            ),
          ],
        ),
      ),
    );
  }
}

class KasirHomeContent extends StatelessWidget {
  KasirHomeContent({super.key});
  final DashboardKasirController controller =
      Get.put(DashboardKasirController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Pembeli Hari Ini",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() => Text(
                    'Jumlah Pembeli: ${controller.jumlahPembeli.value}',
                    style: const TextStyle(fontSize: 16),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
