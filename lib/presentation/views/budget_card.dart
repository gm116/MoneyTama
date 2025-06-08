import 'package:flutter/material.dart';
import '../../../domain/entity/budget.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const BudgetCard({
    super.key,
    required this.budget,
    this.periodStart,
    this.periodEnd,
  });

  Color getBudgetColor(double percentLeft) {
    if (percentLeft > 0.8) return Colors.green;
    if (percentLeft > 0.3) return Colors.yellow[700]!;
    if (percentLeft > 0) return Colors.red;
    return Colors.black;
  }

  String getBudgetStatusText(double percentLeft) {
    if (percentLeft > 0.8) return 'Бюджет в норме';
    if (percentLeft > 0.3) return 'Бюджет тратится быстро';
    if (percentLeft > 0) return 'Бюджет почти на исходе';
    return 'Бюджет превышен';
  }

  @override
  Widget build(BuildContext context) {
    double percentLeft = 1;
    if (budget.plannedAmount > 0) {
      percentLeft = budget.currentBalance / budget.plannedAmount;
    }

    final statusColor = getBudgetColor(percentLeft);
    final statusText = getBudgetStatusText(percentLeft);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Текущий бюджет: ${budget.plannedAmount} ₽',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // черный текст!
              ),
            ),
            Text(
              'Период: ${budget.plannedPeriod == 'MONTHLY'
                  ? 'Месяц'
                  : budget.plannedPeriod == 'WEEKLY'
                  ? 'Неделя'
                  : 'День'}',
              style: const TextStyle(color: Colors.black),
            ),
            if (periodStart != null && periodEnd != null)
              Text(
                'Дата окончания: ${periodEnd!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(color: Colors.black),
              ),
            const SizedBox(height: 8),
            Text(
              'Осталось: ${budget.currentBalance.toStringAsFixed(2)} ₽',
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
      ),
    );
  }
}
