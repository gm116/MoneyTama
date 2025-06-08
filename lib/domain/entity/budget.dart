class Budget {
  final double plannedAmount;
  final String plannedPeriod; // 'MONTHLY', 'WEEKLY', 'DAILY'
  final double currentBalance;

  Budget({
    required this.plannedAmount,
    required this.plannedPeriod,
    required this.currentBalance,
  });

  factory Budget.fromMap(Map<String, dynamic> map) => Budget(
    plannedAmount:
        map['plannedAmount'] is int
            ? (map['plannedAmount'] as int).toDouble()
            : double.parse(map['plannedAmount'].toString()),
    plannedPeriod: map['plannedPeriod'] as String,
    currentBalance:
        map['currentBalance'] is int
            ? (map['currentBalance'] as int).toDouble()
            : double.parse(map['currentBalance'].toString()),
  );

  Map<String, dynamic> toMap() => {
    'plannedAmount': plannedAmount,
    'plannedPeriod': plannedPeriod,
    'currentBalance': currentBalance,
  };

  @override
  String toString() =>
      'Budget(plannedAmount: $plannedAmount, plannedPeriod: $plannedPeriod, currentBalance: $currentBalance)';
}
