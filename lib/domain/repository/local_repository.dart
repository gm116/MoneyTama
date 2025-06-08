import '../entity/operation.dart';
import '../entity/budget.dart';
import '../entity/category.dart';

abstract class LocalRepository {
  // Операции
  Future<void> addOperation(Operation operation);
  Future<List<Operation>> getOperations();
  Future<void> removeOperation(Operation operation);
  /// Вернуть последние [count] операций (если count == 0, вернуть все)
  Future<List<Operation>> getLastOperations({int count = 0});

  // Бюджет
  Future<void> setBudget(Budget budget);
  Future<Budget?> getBudget();

  // Категории
  Future<void> addCategory(Category category);
  Future<List<Category>> getCategories({String? type});
  Future<void> removeCategory(int id);
}