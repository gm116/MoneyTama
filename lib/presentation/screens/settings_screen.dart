import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const SettingsScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: const Text('Настроить бюджет'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/budget');
          },
        ),
        // сюда другие настройки
      ],
    );
  }
}