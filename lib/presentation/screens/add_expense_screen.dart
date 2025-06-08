import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const AddExpenseScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Стоимость, дата, комментарий, категория'),
    );
  }
}
