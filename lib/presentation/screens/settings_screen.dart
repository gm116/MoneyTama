import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const SettingsScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Настройки лимитов и другие параметры'),
    );
  }
}
