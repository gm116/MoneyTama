import '../repository/local_repository.dart';

class RemoveOperationUseCase {
  final LocalRepository _repository;
  RemoveOperationUseCase(this._repository);

  Future<void> execute(String id) async {
    await _repository.removeOperation(id);
  }
} 