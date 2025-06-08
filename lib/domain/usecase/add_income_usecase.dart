import '../entity/operation.dart';
import '../repository/local_repository.dart';

class AddIncomeUseCase {
  final LocalRepository repository;

  AddIncomeUseCase(this.repository);

  Future<void> execute({
    required double sum,
    required DateTime timestamp,
    required String description,
    required String category,
  }) {
    final income = Income(
      category: category,
      sum: sum,
      timestamp: timestamp,
      description: description,
    );
    return repository.addOperation(income);
  }
}