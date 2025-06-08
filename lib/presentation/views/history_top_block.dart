import 'package:flutter/material.dart';

import 'chart_segment.dart';

class HistoryTopBlock extends StatelessWidget {
  final Function() onTap;
  final double total;
  final List<ChartSegment> data;
  final String title;
  final Color color;

  const HistoryTopBlock({
    super.key,
    required this.onTap,
    required this.total,
    required this.data,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: color,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '₽$total',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: data.map((segment) {
                    return Expanded(
                      flex: (segment.percentage * 100).toInt(),
                      child: Container(
                        height: 8,
                        color: segment.color,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
