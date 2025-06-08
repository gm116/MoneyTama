class Operation {
  final double sum;
  final DateTime timestamp;
  String description;

  Operation({
    required this.sum,
    required this.timestamp,
    required this.description,
  });

  @override
  String toString() {
    return 'Operation(sum: $sum, time: $timestamp, description: $description)';
  }
}

class Income extends Operation {
  final String category;

  Income({
    required this.category,
    required super.sum,
    required super.timestamp,
    required super.description,
  });

  @override
  String toString() {
    return 'Income(category: $category, amount: $sum, timestamp: $timestamp, description: $description)';
  }
}

class Expense extends Operation {
  final String category;
  final bool planned;

  Expense({
    required this.planned,
    required this.category,
    required super.sum,
    required super.timestamp,
    required super.description,
  });

  @override
  String toString() {
    return 'Expense(planned: $planned, category: $category, amount: $sum, timestamp: $timestamp, description: $description)';
  }
}
