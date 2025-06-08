import '../entity/budget.dart';
import '../repository/shared_pref_repository.dart';

class GetBudgetUseCase {
  final SharedPrefRepository repository;

  GetBudgetUseCase(this.repository);

  Future<Budget?> execute() async {
    return await repository.getBudget();
  }
}