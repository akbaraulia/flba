import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Barchart extends StatefulWidget {
  const Barchart({super.key});

  @override
  State<Barchart> createState() => _BarchartState();
}

class _BarchartState extends State<Barchart> {
  List<double> sales = [];

  @override
  void initState() {
    super.initState();
    // Simulasi data penjualan 15 hari terakhir
    sales = [10, 15, 8, 20, 18, 12, 25, 30, 28, 14, 18, 22, 30, 24, 20];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 250, 
        child: LineChart(
          LineChartData(
            minY: 0, 
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: (value, meta) => Text(
                    '${value.toInt() + 1}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  sales.length,
                  (index) => FlSpot(index.toDouble(), sales[index]),
                ),
                isCurved: true,
                color: Colors.black,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
