import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const HomeScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главный экран')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Челик сверху в центре'),
          const SizedBox(height: 20),
          const Text('Последние траты'),
          ElevatedButton(
            onPressed: () {
              // Navigate to history
            },
            child: const Text('Перейти на историю'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add expense screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}