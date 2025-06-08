import '../entity/operation.dart';
import '../repository/local_repository.dart';

class AddExpenseUseCase {
  final LocalRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> execute(Expense expense) {
    return repository.addOperation(expense);
  }
}
