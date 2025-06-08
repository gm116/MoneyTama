import '../entity/operation.dart';
import '../repository/local_repository.dart';

class GetOperationsUseCase {
  final LocalRepository _repository;
  GetOperationsUseCase(this._repository);

  Future<List<Operation>> execute() async {
    return await _repository.getOperations();
  }
} 