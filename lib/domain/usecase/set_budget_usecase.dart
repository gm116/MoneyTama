import '../entity/budget.dart';
import '../repository/local_repository.dart';

class SetBudgetUseCase {
  final LocalRepository _repository;
  SetBudgetUseCase(this._repository);

  Future<void> execute(Budget budget) async {
    await _repository.setBudget(budget);
  }
} 