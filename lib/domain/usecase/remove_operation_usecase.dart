import 'package:moneytama/domain/entity/operation.dart';
import '../repository/local_repository.dart';
import '../repository/shared_pref_repository.dart';
import '../entity/budget.dart';

class RemoveOperationUseCase {
  final LocalRepository localRepository;
  final SharedPrefRepository sharedPrefRepository;

  RemoveOperationUseCase(this.localRepository, this.sharedPrefRepository);

  Future<void> execute(Operation operation) async {
    // Удаляем операцию
    await localRepository.removeOperation(operation);

    // Обновляем бюджет
    final budget = await sharedPrefRepository.getBudget();
    if (budget != null) {
      double newBalance = budget.currentBalance;
      if (operation is Expense) {
        newBalance += operation.sum; // Возвращаем трату обратно
      } else if (operation is Income) {
        newBalance -= operation.sum; // Убираем доход
      }
      final updatedBudget = Budget(
        plannedAmount: budget.plannedAmount,
        plannedPeriod: budget.plannedPeriod,
        currentBalance: newBalance,
      );
      await sharedPrefRepository.setBudget(updatedBudget);
    }
  }
}
