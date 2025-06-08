import 'package:flutter/material.dart';

import '../../domain/entity/operation.dart';
import 'analytical_pie_chart.dart';
import 'chart_segment.dart';

class PieChartBlock extends StatelessWidget {
  final String title;
  final List<ChartSegment> data;
  final List<Operation> operations;
  final Function() onClose;
  final double total;

  const PieChartBlock({
    super.key,
    required this.title,
    required this.data,
    required this.operations,
    required this.onClose,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 200,
              width: 200,
              child: AnalyticalPieChart(data: data, title: "$total ₽"),
            ),
          ),
          ...data.map((segment) {
            final operation = operations.firstWhere(
                  (op) => _getCategory(op) == segment.category.toString(),
            );
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: segment.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_getCategory(operation)}: ${segment.percentage
                          .toStringAsFixed(2)}% (${operation.sum} ₽)',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getCategory(Operation operation) {
    if (operation is Income) {
      return operation.category.toString();
    } else if (operation is Expense) {
      return operation.category.toString();
    }
    return 'Другое';
  }
}
