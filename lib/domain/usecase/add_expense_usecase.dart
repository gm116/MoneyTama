import '../entity/operation.dart';
import '../repository/local_repository.dart';
import '../repository/shared_pref_repository.dart';

class AddExpenseUseCase {
  final LocalRepository repository;
  final SharedPrefRepository budgetRepository;

  AddExpenseUseCase(this.repository, this.budgetRepository);

  Future<void> execute(Expense expense) async {
    await repository.addOperation(expense);

    final budget = await budgetRepository.getBudget();
    if (budget != null) {
      final newBalance = budget.currentBalance - expense.sum;
      final updatedBudget = budget.copyWith(currentBalance: newBalance);
      await budgetRepository.setBudget(updatedBudget);
    }
  }
}