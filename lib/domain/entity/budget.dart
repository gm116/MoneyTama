class Budget {
  final int? id;
  final double plannedAmount;
  final String plannedPeriod; // 'MONTHLY', 'WEEKLY', 'DAILY'
  final double currentBalance;

  Budget({
    this.id,
    required this.plannedAmount,
    required this.plannedPeriod,
    required this.currentBalance,
  });

  factory Budget.fromMap(Map<String, dynamic> map) => Budget(
    id: map['id'] as int?,
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
    'id': id,
    'plannedAmount': plannedAmount,
    'plannedPeriod': plannedPeriod,
    'currentBalance': currentBalance,
  };

  @override
  String toString() =>
      'Budget(id: $id, plannedAmount: $plannedAmount, plannedPeriod: $plannedPeriod, currentBalance: $currentBalance)';
}
