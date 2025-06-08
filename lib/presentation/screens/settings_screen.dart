import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const SettingsScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final locale = localeProvider.locale ?? Localizations.localeOf(context);

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
        const SizedBox(height: 24),
        const Text(
          'Язык приложения:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<Locale>(
          value: locale,
          items: const [
            DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
            DropdownMenuItem(value: Locale('en'), child: Text('English')),
          ],
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localeProvider.setLocale(newLocale);
            }
          },
        ),
        // Здесь будут другие настройки
      ],
    );
  }
}
