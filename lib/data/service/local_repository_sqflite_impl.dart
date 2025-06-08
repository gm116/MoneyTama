import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/entity/operation.dart';
import '../../domain/entity/budget.dart';
import '../../domain/entity/category.dart';
import '../../domain/repository/local_repository.dart';

class LocalRepositorySqfliteImpl implements LocalRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final db = await openDatabase(
      join(dbPath, 'moneytama.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE operations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sum REAL,
            timestamp TEXT,
            description TEXT,
            type TEXT,         -- 'income' или 'expense'
            category TEXT,
            planned INTEGER     -- 0 или 1, только для расходов, для доходов всегда 0
          )
        ''');
        await db.execute('''
          CREATE TABLE budgets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plannedAmount REAL,
            plannedPeriod TEXT,
            currentBalance REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            type TEXT,
            isCustom INTEGER
          )
        ''');

        // Дефолтные категории расходов
        await db.insert('categories', {
          'name': 'FOOD',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'TRANSPORT',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'MEDICINE',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'EDUCATION',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'ENTERTAINMENT',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'BEAUTY',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'MONEY TRANSFERS',
          'type': 'expense',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'OTHER',
          'type': 'expense',
          'isCustom': 0,
        });

        // Дефолтные категории доходов
        await db.insert('categories', {
          'name': 'SALARY',
          'type': 'income',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'MONEY TRANSFERS',
          'type': 'income',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'ESTATE INCOMES',
          'type': 'income',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'PAYMENTS',
          'type': 'income',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'DEPOSIT PAYMENTS',
          'type': 'income',
          'isCustom': 0,
        });
        await db.insert('categories', {
          'name': 'OTHER',
          'type': 'income',
          'isCustom': 0,
        });
      },
    );
    return db;
  }

  // ---------------------- Operation ----------------------

  /// Добавить доход
  Future<void> addIncome(Income income) async {
    final db = await database;
    await db.insert('operations', {
      'sum': income.sum,
      'timestamp': income.timestamp.toIso8601String(),
      'description': income.description,
      'type': 'income',
      'category': income.category,
      'planned': 0,
    });
  }

  @override
  Future<void> addOperation(Operation operation) async {
    if (operation is Income) {
      await addIncome(operation);
    } else if (operation is Expense) {
      await addExpense(operation);
    } else {
      throw Exception('Unsupported operation type');
    }
  }

  /// Добавить расход
  Future<void> addExpense(Expense expense) async {
    final db = await database;
    await db.insert('operations', {
      'sum': expense.sum,
      'timestamp': expense.timestamp.toIso8601String(),
      'description': expense.description,
      'type': 'expense',
      'category': expense.category,
      'planned': expense.planned ? 1 : 0,
    });
  }

  /// Получить все операции (универсально)
  @override
  Future<List<Operation>> getOperations() async {
    final db = await database;
    final maps = await db.query('operations', orderBy: 'timestamp DESC');
    return maps.map(_mapToOperation).toList();
  }

  /// Получить последние N операций
  @override
  Future<List<Operation>> getLastOperations({int count = 0}) async {
    final db = await database;
    final maps = await db.query(
      'operations',
      orderBy: 'timestamp DESC',
      limit: count == 0 ? null : count,
    );
    return maps.map(_mapToOperation).toList();
  }

  /// Удалить операцию по id
  @override
  Future<void> removeOperation(String id) async {
    final db = await database;
    await db.delete('operations', where: 'id = ?', whereArgs: [int.parse(id)]);
  }

  /// Маппер: возвращает Income или Expense в зависимости от поля type
  Operation _mapToOperation(Map<String, dynamic> map) {
    if (map['type'] == 'income') {
      return Income(
        category: map['category'],
        sum:
            map['sum'] is int
                ? (map['sum'] as int).toDouble()
                : double.parse(map['sum'].toString()),
        timestamp: DateTime.parse(map['timestamp']),
        description: map['description'],
      );
    } else {
      return Expense(
        planned: map['planned'] == 1,
        category: map['category'],
        sum:
            map['sum'] is int
                ? (map['sum'] as int).toDouble()
                : double.parse(map['sum'].toString()),
        timestamp: DateTime.parse(map['timestamp']),
        description: map['description'],
      );
    }
  }

  // ---------------------- Budget ----------------------
  @override
  Future<void> setBudget(Budget budget) async {
    final db = await database;
    await db.delete('budgets');
    await db.insert('budgets', budget.toMap());
  }

  @override
  Future<Budget?> getBudget() async {
    final db = await database;
    final maps = await db.query('budgets');
    if (maps.isNotEmpty) {
      return Budget.fromMap(maps.first);
    }
    return null;
  }

  // ---------------------- Category ----------------------
  Future<void> addCategory(Category category) async {
    final db = await database;
    await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategories({String? type}) async {
    final db = await database;
    final maps =
        type == null
            ? await db.query('categories')
            : await db.query(
              'categories',
              where: 'type = ?',
              whereArgs: [type],
            );
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  Future<void> removeCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
