import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/home/controllers/dashboard_controller.dart';

class Barchart extends StatelessWidget {
  final DashboardController controller = Get.find();

  Barchart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.penjualanData;
      if (data.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Pastikan 'total_penjualan' adalah double
      final maxYValue = data
          .map((e) => double.tryParse(e['total_penjualan'].toString()) ?? 0.0) // Mengonversi String ke double
          .reduce((a, b) => a > b ? a : b) * 1.2;

      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxYValue,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final int index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  final label = data[index]['date'].toString().substring(5); // Ambil MM-DD
                  return Text(label, style: const TextStyle(fontSize: 10));
                },
                interval: 1,
              ),
            ),
          ),
          barGroups: data.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            return BarChartGroupData(x: index, barRods: [
              BarChartRodData(
                toY: double.tryParse(item['total_penjualan'].toString()) ?? 0.0, // Pastikan total_penjualan menjadi double
                color: Colors.blue,
                width: 14,
                borderRadius: BorderRadius.circular(4),
              ),
            ]);
          }).toList(),
        ),
      );
    });
  }
}



// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kasir/app/modules/home/controllers/dashboard_controller.dart';

// class Barchart extends StatelessWidget {
//   final DashboardController controller = Get.find();

//   Barchart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final data = controller.penjualanData;
//       if (data.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       // Pastikan 'total_penjualan' adalah double
//       final sales = data
//           .map((e) => double.tryParse(e['total_penjualan'].toString()) ?? 0.0)
//           .toList();

//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           height: 250, 
//           child: LineChart(
//             LineChartData(
//               minY: 0, 
//               gridData: FlGridData(show: true),
//               titlesData: FlTitlesData(
//                 show: true,
//                 topTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 5,
//                     getTitlesWidget: (value, meta) => Text(
//                       value.toInt().toString(),
//                       style: const TextStyle(fontSize: 10),
//                     ),
//                   ),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: 2,
//                     getTitlesWidget: (value, meta) {
//                       final int index = value.toInt();
//                       if (index < 0 || index >= data.length) return const SizedBox();
//                       final label = data[index]['date'].toString().substring(5); // Ambil MM-DD
//                       return Text(label, style: const TextStyle(fontSize: 10));
//                     },
//                   ),
//                 ),
//               ),
//               borderData: FlBorderData(show: true),
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: List.generate(
//                     sales.length,
//                     (index) => FlSpot(index.toDouble(), sales[index]),
//                   ),
//                   isCurved: true,
//                   color: Colors.blue,
//                   barWidth: 3,
//                   isStrokeCapRound: true,
//                   belowBarData: BarAreaData(show: false),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
