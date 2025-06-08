import '../entity/operation.dart';
import '../repository/local_repository.dart';

class AddExpenseUseCase {
  final LocalRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> execute({
    required double sum,
    required DateTime timestamp,
    required String description,
    required String category,
    required bool planned,
  }) {
    final expense = Expense(
      planned: planned,
      category: category,
      sum: sum,
      timestamp: timestamp,
      description: description,
    );
    return repository.addOperation(expense);
  }
}