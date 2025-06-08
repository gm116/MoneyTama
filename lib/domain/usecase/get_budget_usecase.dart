import '../entity/budget.dart';
import '../repository/local_repository.dart';

class GetBudgetUseCase {
  final LocalRepository repository;

  GetBudgetUseCase(this.repository);

  Future<Budget?> execute() => repository.getBudget();
}
