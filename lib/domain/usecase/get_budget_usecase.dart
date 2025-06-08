import '../entity/budget.dart';
import '../repository/local_repository.dart';

class GetBudgetUseCase {
  final LocalRepository _repository;
  GetBudgetUseCase(this._repository);

  Future<Budget?> execute() async {
    return await _repository.getBudget();
  }
} 