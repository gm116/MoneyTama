import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecase/get_operations_usecase.dart';
import '../../domain/utils/export_csv.dart';
import '../di/di.dart';
import '../state/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entity/budget.dart';
import '../views/budget_card.dart';
import '../views/budget_form.dart';

class SettingsScreen extends StatefulWidget {
  final Function(int) updateIndex;

  const SettingsScreen({super.key, required this.updateIndex});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Budget? _budget;
  DateTime? _periodStart;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _periodType = 'MONTHLY';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final plannedAmount = prefs.getDouble('budget_planned_amount');
    final plannedPeriod = prefs.getString('budget_planned_period');
    final currentBalance = prefs.getDouble('budget_current_balance');
    final periodStartString = prefs.getString('budget_period_start');
    DateTime? periodStart =
    periodStartString != null ? DateTime.tryParse(periodStartString) : null;

    if (plannedAmount != null &&
        plannedPeriod != null &&
        currentBalance != null) {
      _budget = Budget(
        plannedAmount: plannedAmount,
        plannedPeriod: plannedPeriod,
        currentBalance: currentBalance,
      );
    }
    _periodStart = periodStart;
    setState(() {
      _loading = false;
      _periodType = _budget?.plannedPeriod ?? 'MONTHLY';
      _amountController.text = _budget?.plannedAmount.toStringAsFixed(0) ?? '';
    });
  }

  DateTime? getPeriodEnd(DateTime? start, String type) {
    if (start == null) return null;
    switch (type) {
      case 'DAILY':
        return start.add(const Duration(days: 1));
      case 'WEEKLY':
        return start.add(const Duration(days: 7));
      case 'MONTHLY':
        return DateTime(start.year, start.month + 1, start.day);
      default:
        return null;
    }
  }

  Future<void> _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      await prefs.setDouble('budget_planned_amount', amount);
      await prefs.setString('budget_planned_period', _periodType);
      await prefs.setDouble('budget_current_balance', amount);
      await prefs.setString(
        'budget_period_start',
        DateTime.now().toIso8601String(),
      );

      setState(() {
        _budget = Budget(
          plannedAmount: amount,
          plannedPeriod: _periodType,
          currentBalance: amount,
        );
        _periodStart = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.budget_success_saved),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final locale = localeProvider.locale ?? Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    double percentLeft = 1;
    if (_budget != null && _budget!.plannedAmount > 0) {
      percentLeft = _budget!.currentBalance / _budget!.plannedAmount;
    }

    final periodEnd = getPeriodEnd(_periodStart, _periodType);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.settings_title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.budget,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_budget != null)
                BudgetCard(
                  budget: _budget!,
                  periodStart: _periodStart,
                  periodEnd: periodEnd,
                  backgroundColor: percentLeft > 0.3
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.tertiaryContainer,
                ),
              const SizedBox(height: 8),
              Text(
                l10n.budget_edit_limit,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BudgetForm(
                formKey: _formKey,
                amountController: _amountController,
                periodType: _periodType,
                onPeriodChanged: (v) {
                  setState(() {
                    _periodType = v!;
                  });
                },
                onSave: _saveBudget,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          l10n.settings_language,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: locale,
              borderRadius: BorderRadius.circular(8),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: const Locale('ru'),
                  child: Row(
                    children: [
                      const Text("🇷🇺", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      const Text('Русский', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Row(
                    children: [
                      const Text("🇬🇧", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      const Text('English', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeProvider.setLocale(newLocale);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.download_rounded),
          title: Text(l10n.export_csv), // Локализовано!
          onTap: () async {
            final operationsList = await getIt<GetOperationsUseCase>().execute();
            if (operationsList.isNotEmpty) {
              await exportOperationsToCsv(operationsList, context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.export_csv_success))
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.export_csv_empty))
              );
            }
          },
        ),
      ],
    );
  }
}