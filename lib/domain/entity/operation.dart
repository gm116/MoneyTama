class Operation {
  final double _sum;
  final DateTime _timestamp;
  final String _description;

  Operation(this._sum, this._timestamp, [String description = ""])
      : _description = description;

  double get sum => _sum;
  DateTime get timestamp => _timestamp;
  String get description => _description;

  @override
  String toString() {
    return 'Operation(sum: $sum, time: $timestamp, description: $description)';
  }
}

class Income extends Operation {
  final String _category;

  String get category => _category;


  Income({
    required double sum,
    required DateTime timestamp,
    String description = "",
    required String category,
  })  : _category = category,
        super(sum, timestamp, description);

  @override
  String toString() {
    return 'Income(category: $category, amount: $sum, timestamp: $timestamp, description: $description)';
  }
}

class Expense extends Operation {
  final String _category;
  final bool _planned;

  String get category => _category;
  bool get planned => _planned;


  Expense({
    required double sum,
    required DateTime timestamp,
    String description = "",
    required String category,
    required bool planned,
  })  : _category = category,
        _planned = planned,
        super(sum, timestamp, description);

  @override
  String toString() {
    return 'Expense(planned: $planned, category: $category, amount: $sum, timestamp: $timestamp, description: $description)';
  }
}
