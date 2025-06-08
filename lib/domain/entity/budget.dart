import 'operation.dart';

class Budget {
  final double plannedAmount;
  Period plannedPeriod;
  double currentBalance;

  Budget({
    required this.plannedAmount,
    required this.plannedPeriod,
    this.currentBalance = 0.0,
  });

  void performOperation(Operation op) {
    currentBalance += op.sum;
  }

  @override
  String toString() {
    return 'Budget(plannedAmount: $plannedAmount, period: $plannedPeriod, currentBalance: $currentBalance)';
  }
}

enum Period {
  monthly,
  weekly,
  daily,
}