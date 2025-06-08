class Operation {
  final int? id;
  final double sum;
  final DateTime timestamp;
  final String description;
  final String type; // 'income' или 'expense'
  final String category;

  Operation({
    this.id,
    required this.sum,
    required this.timestamp,
    required this.description,
    required this.type,
    required this.category,
  });

  factory Operation.fromMap(Map<String, dynamic> map) => Operation(
    id: map['id'] as int?,
    sum:
        map['sum'] is int
            ? (map['sum'] as int).toDouble()
            : double.parse(map['sum'].toString()),
    timestamp: DateTime.parse(map['timestamp'] as String),
    description: map['description'] as String,
    type: map['type'] as String,
    category: map['category'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'sum': sum,
    'timestamp': timestamp.toIso8601String(),
    'description': description,
    'type': type,
    'category': category,
  };

  @override
  String toString() =>
      'Operation(id: $id, sum: $sum, timestamp: $timestamp, description: $description, type: $type, category: $category)';
}
