import '../entity/operation.dart';
import '../repository/local_repository.dart';

class GetOperationsUseCase {
  final LocalRepository repository;
  GetOperationsUseCase(this.repository);

  Future<List<Operation>> execute() => repository.getOperations();
}