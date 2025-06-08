import '../entity/budget.dart';
import '../repository/local_repository.dart';

class SetBudgetUseCase {
  final LocalRepository repository;

  SetBudgetUseCase(this.repository);

  Future<void> execute(Budget budget) => repository.setBudget(budget);
}
