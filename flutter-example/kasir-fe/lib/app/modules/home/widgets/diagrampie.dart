import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/home/controllers/dashboard_controller.dart';

class Diagrampie extends StatelessWidget {
  final DashboardController controller = Get.find();

  Diagrampie({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.persentaseProduk;
      if (data.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Hitung total semua produk terjual
      final totalAll = data.fold<num>(0, (sum, item) => sum + (item['total_terjual'] ?? 0));

      return Column(
        children: [
          // PieChart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: data.map((item) {
                  final total = item['total_terjual'] ?? 0;
                  final persen = totalAll == 0 ? 0 : (total / totalAll) * 100;

                  return PieChartSectionData(
                    value: persen,
                    title: "${persen.toStringAsFixed(1)}%",
                    color: _getRandomColor(item['name_product'] ?? ''),
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Column(
            children: data.map((item) {
              final color = _getRandomColor(item['name_product'] ?? '');
              return Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: color,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item['name_product'] ?? 'Produk Tidak Diketahui',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Color _getRandomColor(String input) {
    final hash = input.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;
    return Color.fromRGBO(r, g, b, 1.0);
  }
}
