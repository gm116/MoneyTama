import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const HomeScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
          ]
      ),
    );
  }
}
