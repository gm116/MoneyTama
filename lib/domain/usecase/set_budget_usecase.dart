import '../entity/budget.dart';
import '../repository/shared_pref_repository.dart';

class SetBudgetUseCase {
  final SharedPrefRepository repository;

  SetBudgetUseCase(this.repository);

  Future<void> execute(Budget budget) async {
    await repository.setBudget(budget);
  }
}