import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entity/budget.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final Color backgroundColor;

  const BudgetCard({
    super.key,
    required this.budget,
    this.periodStart,
    this.periodEnd,
    required this.backgroundColor,
  });

  String getBudgetStatusText(BuildContext context, double percentLeft) {
    final l10n = AppLocalizations.of(context)!;
    if (percentLeft > 0.8) return l10n.budget_status_good;
    if (percentLeft > 0.3) return l10n.budget_status_warning;
    if (percentLeft > 0) return l10n.budget_status_low;
    return l10n.budget_status_over;
  }

  String getPeriodText(BuildContext context, String periodType) {
    final l10n = AppLocalizations.of(context)!;
    switch (periodType) {
      case 'MONTHLY':
        return l10n.budget_period_monthly;
      case 'WEEKLY':
        return l10n.budget_period_weekly;
      case 'DAILY':
        return l10n.budget_period_daily;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    double percentLeft = 1;
    if (budget.plannedAmount > 0) {
      percentLeft = budget.currentBalance / budget.plannedAmount;
    }

    final statusText = getBudgetStatusText(context, percentLeft);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.budget_current(budget.plannedAmount.toStringAsFixed(0)),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            '${l10n.budget_period}: ${getPeriodText(context, budget.plannedPeriod)}',
            style: const TextStyle(color: Colors.black),
          ),
          if (periodStart != null && periodEnd != null)
            Text(
              l10n.budget_period_ends(periodEnd!.toLocal().toString().split(' ')[0]),
              style: const TextStyle(color: Colors.black),
            ),
          const SizedBox(height: 8),
          Text(
            l10n.budget_remaining(budget.currentBalance.toStringAsFixed(0)),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}