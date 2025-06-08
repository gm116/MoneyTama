import '../entity/operation.dart';
import '../entity/budget.dart';

abstract class LocalRepository {
  // Операции (расходы/доходы)
  Future<void> addOperation(Operation operation);
  Future<List<Operation>> getOperations();
  Future<void> removeOperation(String id);

  // Бюджет
  Future<void> setBudget(Budget budget);
  Future<Budget?> getBudget();

}