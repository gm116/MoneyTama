import '../../domain/entity/operation.dart';
import '../../domain/entity/budget.dart';

abstract class LocalDataSource {
  Future<void> saveOperation(Operation operation);
  Future<List<Operation>> getOperations();
  Future<void> deleteOperation(String id);
  Future<void> saveBudget(Budget budget);
  Future<Budget?> getBudget();
} 