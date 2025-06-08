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
            type TEXT,
            category TEXT
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
  @override
  Future<void> addOperation(Operation operation) async {
    final db = await database;
    await db.insert('operations', operation.toMap());
  }

  @override
  Future<List<Operation>> getLastOperations({int count = 0}) async {
    final db = await database;
    final maps = await db.query(
      'operations',
      orderBy: 'timestamp DESC',
      limit: count == 0 ? null : count,
    );
    return maps.map((map) => Operation.fromMap(map)).toList();
  }

  @override
  Future<List<Operation>> getOperations() async {
    final db = await database;
    final maps = await db.query('operations', orderBy: 'timestamp DESC');
    return maps.map((map) => Operation.fromMap(map)).toList();
  }

  @override
  Future<void> removeOperation(String id) async {
    final db = await database;
    await db.delete('operations', where: 'id = ?', whereArgs: [int.parse(id)]);
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
