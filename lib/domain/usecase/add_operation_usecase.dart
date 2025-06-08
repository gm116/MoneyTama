import '../entity/operation.dart';
import '../repository/local_repository.dart';

class AddOperationUseCase {
  final LocalRepository repository;

  AddOperationUseCase(this.repository);

  Future<void> execute(Operation operation) =>
      repository.addOperation(operation);
}
