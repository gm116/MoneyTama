class Category {
  final int? id;
  final String name;
  final String type; // 'income' или 'expense'
  final bool isCustom; // false — дефолтная, true — пользовательская

  Category({
    this.id,
    required this.name,
    required this.type,
    required this.isCustom,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int?,
    name: map['name'] as String,
    type: map['type'] as String,
    isCustom: (map['isCustom'] as int) == 1,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'isCustom': isCustom ? 1 : 0,
  };

  @override
  String toString() =>
      'Category(id: $id, name: $name, type: $type, isCustom: $isCustom)';
}
