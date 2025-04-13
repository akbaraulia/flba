import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Diagrampie extends StatefulWidget {
  const Diagrampie({super.key});

  @override
  State<Diagrampie> createState() => _DiagrampieState();
}

class _DiagrampieState extends State<Diagrampie> {
  final List<Map<String, dynamic>> legendData = const [
    {"color": Colors.black, "label": "Produk A"},
    {"color": Colors.grey, "label": "Produk B"},
    {"color": Colors.blueGrey, "label": "Produk C"},
    {"color": Colors.brown, "label": "Produk D"},
  ];

  final List<PieChartSectionData> pieSections =  [
    PieChartSectionData(value: 40, color: Colors.black, showTitle: false),
    PieChartSectionData(value: 30, color: Colors.grey, showTitle: false),
    PieChartSectionData(value: 20, color: Colors.blueGrey, showTitle: false),
    PieChartSectionData(value: 10, color: Colors.brown, showTitle: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: legendData
              .map((data) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: data['color'],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(data['label'], style: const TextStyle(fontSize: 12)),
                    ],
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: pieSections,
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
      ],
    );
  }
}
