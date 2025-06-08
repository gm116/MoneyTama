import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entity/budget.dart';
import '../views/budget_card.dart';
import '../views/budget_form.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
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
      _amountController.text = _budget?.plannedAmount.toStringAsFixed(2) ?? '';
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Бюджет успешно сохранён')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final periodEnd = getPeriodEnd(_periodStart, _periodType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Бюджет'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_budget != null)
              BudgetCard(
                budget: _budget!,
                periodStart: _periodStart,
                periodEnd: periodEnd,
              ),
            const SizedBox(height: 8),
            const Text(
              'Изменить лимит бюджета:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
    );
  }
}