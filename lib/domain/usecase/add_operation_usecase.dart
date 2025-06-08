import '../entity/operation.dart';
import '../repository/local_repository.dart';

class AddOperationUseCase {
  final LocalRepository _repository;
  AddOperationUseCase(this._repository);

  Future<void> execute(Operation operation) async {
    await _repository.addOperation(operation);
  }
} 