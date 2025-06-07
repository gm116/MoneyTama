import 'package:flutter/material.dart';

class DecorationScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const DecorationScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Украшение питомца')),
      body: Center(
        child: const Text('Цвета + демо-шляпки'),
      ),
    );
  }
}
