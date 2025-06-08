import '../repository/local_repository.dart';

class RemoveOperationUseCase {
  final LocalRepository repository;

  RemoveOperationUseCase(this.repository);

  Future<void> execute(String id) => repository.removeOperation(id);
}
