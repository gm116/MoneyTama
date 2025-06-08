import '../entity/operation.dart';
import '../repository/local_repository.dart';

class AddIncomeUseCase {
  final LocalRepository repository;

  AddIncomeUseCase(this.repository);

  Future<void> execute(Income income) async {
    return repository.addOperation(income);
  }
}
