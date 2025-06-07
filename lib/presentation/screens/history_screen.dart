import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const HistoryScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История расходов')),
      body: Center(
        child: const Text('Полная история расходов + диаграммы'),
      ),
    );
  }
}