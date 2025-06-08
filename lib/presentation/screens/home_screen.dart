import 'package:flutter/material.dart';
import 'package:moneytama/presentation/di/di.dart';
import 'package:moneytama/presentation/screens/add_operation_screen.dart';

import '../navigation/navigation_service.dart';

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
            ElevatedButton(
              onPressed: () {
                getIt<NavigationService>().navigateTo(AddOperationScreen.routeName);
              },
              child: const Text('Добавить расход'),
            ),
          ]
      ),
    );
  }
}
