import 'package:flutter/material.dart';

import '../views/analytical_pie_chart.dart';

class HistoryScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const HistoryScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnalyticalPieChart(
        data: [
          PieChartSegment(percentage: 50.0, color: Colors.red),
          PieChartSegment(percentage: 30.0, color: Colors.blue),
          PieChartSegment(percentage: 15.0, color: Colors.green),
          PieChartSegment(percentage: 5.0, color: Colors.yellow),
        ],
      ),
    );
  }
}
