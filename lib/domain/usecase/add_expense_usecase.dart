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
  }) {
    final operation = Operation(
      sum: sum,
      timestamp: timestamp,
      description: description,
      type: 'expense',
      category: category,
    );
    return repository.addOperation(operation);
  }
}
