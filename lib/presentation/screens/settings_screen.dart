import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  final Function(int) updateIndex;

  const SettingsScreen({super.key, required this.updateIndex});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final locale = localeProvider.locale ?? Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: Text(l10n.settings_budget),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/budget');
          },
        ),
        const SizedBox(height: 24),
        Text(
          "${l10n.settings_language}:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<Locale>(
          value: locale,
          items: [
            DropdownMenuItem(value: const Locale('ru'), child: Text(l10n.settings_select_language == "Выберите язык" ? "Русский" : "Russian")),
            DropdownMenuItem(value: const Locale('en'), child: Text(l10n.settings_select_language == "Выберите язык" ? "Английский" : "English")),
          ],
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localeProvider.setLocale(newLocale);
            }
          },
        ),
      ],
    );
  }
}