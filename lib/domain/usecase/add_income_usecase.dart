import '../entity/operation.dart';
import '../repository/local_repository.dart';
import '../repository/shared_pref_repository.dart';

class AddIncomeUseCase {
  final LocalRepository repository;
  final SharedPrefRepository budgetRepository;

  AddIncomeUseCase(this.repository, this.budgetRepository);

  Future<void> execute(Income income) async {
    await repository.addOperation(income);

    final budget = await budgetRepository.getBudget();
    if (budget != null) {
      final newBalance = budget.currentBalance + income.sum;
      final updatedBudget = budget.copyWith(currentBalance: newBalance);
      await budgetRepository.setBudget(updatedBudget);
    }
  }
}