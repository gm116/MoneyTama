// // НУЖНО УДАЛИТЬ
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import '../../domain/entity/operation.dart';
// import '../../domain/entity/budget.dart';
// import '../../domain/entity/category.dart';
// import 'local_datasource.dart';
//
// class SharedPrefsDataSource implements LocalDataSource {
//   final SharedPreferences _prefs;
//   static const String _operationsKey = 'operations';
//   static const String _budgetKey = 'budget';
//   static const String _categoriesKey = 'categories';
//
//   SharedPrefsDataSource(this._prefs);
//
//   @override
//   Future<void> saveOperation(Operation operation) async {
//     final operations = await getOperations();
//     operations.add(operation);
//     await _saveOperations(operations);
//   }
//
//   @override
//   Future<List<Operation>> getOperations() async {
//     final operationsJson = _prefs.getStringList(_operationsKey) ?? [];
//     return operationsJson.map((json) {
//       final map = jsonDecode(json) as Map<String, dynamic>;
//       if (map['type'] == 'income') {
//         return Income(
//           category: IncomeCategory.values.firstWhere(
//             (e) => e.toString() == map['category'],
//           ),
//           sum: map['sum'],
//           timestamp: DateTime.parse(map['timestamp']),
//           description: map['description'],
//         );
//       } else {
//         return Expense(
//           category: ExpenseCategory.values.firstWhere(
//             (e) => e.toString() == map['category'],
//           ),
//           planned: map['planned'],
//           sum: map['sum'],
//           timestamp: DateTime.parse(map['timestamp']),
//           description: map['description'],
//         );
//       }
//     }).toList();
//   }
//
//   @override
//   Future<void> deleteOperation(String id) async {
//     final operations = await getOperations();
//     operations.removeWhere((op) => op.toString() == id);
//     await _saveOperations(operations);
//   }
//
//   @override
//   Future<void> saveBudget(Budget budget) async {
//     final budgetJson = jsonEncode({
//       'plannedAmount': budget.plannedAmount,
//       'plannedPeriod': budget.plannedPeriod.toString(),
//       'currentBalance': budget.currentBalance,
//     });
//     await _prefs.setString(_budgetKey, budgetJson);
//   }
//
//   @override
//   Future<Budget?> getBudget() async {
//     final budgetJson = _prefs.getString(_budgetKey);
//     if (budgetJson == null) return null;
//
//     final map = jsonDecode(budgetJson) as Map<String, dynamic>;
//     return Budget(
//       plannedAmount: map['plannedAmount'],
//       plannedPeriod: Period.values.firstWhere(
//         (e) => e.toString() == map['plannedPeriod'],
//       ),
//       currentBalance: map['currentBalance'],
//     );
//   }
//
//   @override
//   Future<void> addCategory(Category category) async {
//     final categories = await getCategories();
//     categories.add(category);
//     await _saveCategories(categories);
//   }
//
//   @override
//   Future<List<Category>> getCategories() async {
//     final categoriesJson = _prefs.getStringList(_categoriesKey) ?? [];
//     if (categoriesJson.isEmpty) {
//       // Добавляем дефолтные категории при первом запуске
//       final defaultCategories = _getDefaultCategories();
//       await _saveCategories(defaultCategories);
//       return defaultCategories;
//     }
//     return categoriesJson.map((json) {
//       final map = jsonDecode(json) as Map<String, dynamic>;
//       return Category.fromJson(map);
//     }).toList();
//   }
//
//   @override
//   Future<void> removeCategory(String id) async {
//     final categories = await getCategories();
//     categories.removeWhere((cat) => cat.id == id);
//     await _saveCategories(categories);
//   }
//
//   @override
//   Future<List<Category>> getIncomeCategories() async {
//     final categories = await getCategories();
//     return categories.where((cat) => cat.isIncome).toList();
//   }
//
//   @override
//   Future<List<Category>> getExpenseCategories() async {
//     final categories = await getCategories();
//     return categories.where((cat) => !cat.isIncome).toList();
//   }
//
//   Future<void> _saveOperations(List<Operation> operations) async {
//     final operationsJson = operations.map((op) {
//       final map = {
//         'type': op is Income ? 'income' : 'expense',
//         'sum': op.sum,
//         'timestamp': op.timestamp.toIso8601String(),
//         'description': op.description,
//       };
//
//       if (op is Income) {
//         map['category'] = op.category.toString();
//       } else if (op is Expense) {
//         map['category'] = op.category.toString();
//         map['planned'] = op.planned;
//       }
//
//       return jsonEncode(map);
//     }).toList();
//
//     await _prefs.setStringList(_operationsKey, operationsJson);
//   }
//
//   Future<void> _saveCategories(List<Category> categories) async {
//     final categoriesJson = categories.map((cat) => jsonEncode(cat.toJson())).toList();
//     await _prefs.setStringList(_categoriesKey, categoriesJson);
//   }
//
//   List<Category> _getDefaultCategories() {
//     return [
//       // Доходы
//       Category(id: const Uuid().v4(), name: 'Зарплата', isIncome: true),
//       Category(id: const Uuid().v4(), name: 'Переводы', isIncome: true),
//       Category(id: const Uuid().v4(), name: 'Доходы от недвижимости', isIncome: true),
//       Category(id: const Uuid().v4(), name: 'Платежи', isIncome: true),
//       Category(id: const Uuid().v4(), name: 'Проценты по вкладу', isIncome: true),
//       Category(id: const Uuid().v4(), name: 'Другое', isIncome: true),
//
//       // Расходы
//       Category(id: const Uuid().v4(), name: 'Еда', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Транспорт', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Медицина', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Образование', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Красота', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Развлечения', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Переводы', isIncome: false),
//       Category(id: const Uuid().v4(), name: 'Другое', isIncome: false),
//     ];
//   }
// }