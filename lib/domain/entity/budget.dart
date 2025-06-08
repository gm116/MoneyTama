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

  Budget copyWith({int? id, double? plannedAmount, String? plannedPeriod, double? currentBalance}) {
    return Budget(
      plannedAmount: plannedAmount ?? this.plannedAmount,
      plannedPeriod: plannedPeriod ?? this.plannedPeriod,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }

  Map<String, dynamic> toMap() => {
    'plannedAmount': plannedAmount,
    'plannedPeriod': plannedPeriod,
    'currentBalance': currentBalance,
  };

  @override
  String toString() =>
      'Budget(plannedAmount: $plannedAmount, plannedPeriod: $plannedPeriod, currentBalance: $currentBalance)';
}
