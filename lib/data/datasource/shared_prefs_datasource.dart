import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entity/operation.dart';
import '../../domain/entity/budget.dart';
import 'local_datasource.dart';

class SharedPrefsDataSource implements LocalDataSource {
  final SharedPreferences _prefs;
  static const String _operationsKey = 'operations';
  static const String _budgetKey = 'budget';

  SharedPrefsDataSource(this._prefs);

  @override
  Future<void> saveOperation(Operation operation) async {
    final operations = await getOperations();
    operations.add(operation);
    await _saveOperations(operations);
  }

  @override
  Future<List<Operation>> getOperations() async {
    final operationsJson = _prefs.getStringList(_operationsKey) ?? [];
    return operationsJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      if (map['type'] == 'income') {
        return Income(
          category: IncomeCategory.values.firstWhere(
            (e) => e.toString() == map['category'],
          ),
          sum: map['sum'],
          timestamp: DateTime.parse(map['timestamp']),
          description: map['description'],
        );
      } else {
        return Expense(
          category: ExpenseCategory.values.firstWhere(
            (e) => e.toString() == map['category'],
          ),
          planned: map['planned'],
          sum: map['sum'],
          timestamp: DateTime.parse(map['timestamp']),
          description: map['description'],
        );
      }
    }).toList();
  }

  @override
  Future<void> deleteOperation(String id) async {
    final operations = await getOperations();
    operations.removeWhere((op) => op.toString() == id);
    await _saveOperations(operations);
  }

  @override
  Future<void> saveBudget(Budget budget) async {
    final budgetJson = jsonEncode({
      'plannedAmount': budget.plannedAmount,
      'plannedPeriod': budget.plannedPeriod.toString(),
      'currentBalance': budget.currentBalance,
    });
    await _prefs.setString(_budgetKey, budgetJson);
  }

  @override
  Future<Budget?> getBudget() async {
    final budgetJson = _prefs.getString(_budgetKey);
    if (budgetJson == null) return null;

    final map = jsonDecode(budgetJson) as Map<String, dynamic>;
    return Budget(
      plannedAmount: map['plannedAmount'],
      plannedPeriod: Period.values.firstWhere(
        (e) => e.toString() == map['plannedPeriod'],
      ),
      currentBalance: map['currentBalance'],
    );
  }

  Future<void> _saveOperations(List<Operation> operations) async {
    final operationsJson = operations.map((op) {
      final map = {
        'type': op is Income ? 'income' : 'expense',
        'sum': op.sum,
        'timestamp': op.timestamp.toIso8601String(),
        'description': op.description,
      };

      if (op is Income) {
        map['category'] = op.category.toString();
      } else if (op is Expense) {
        map['category'] = op.category.toString();
        map['planned'] = op.planned;
      }

      return jsonEncode(map);
    }).toList();

    await _prefs.setStringList(_operationsKey, operationsJson);
  }
} 