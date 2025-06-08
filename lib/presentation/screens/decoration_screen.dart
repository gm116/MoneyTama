import 'package:flutter/material.dart';

class DecorationScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const DecorationScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Цвета + демо-шляпки'),
    );
  }
}
