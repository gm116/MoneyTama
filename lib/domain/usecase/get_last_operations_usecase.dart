import '../entity/operation.dart';
import '../repository/local_repository.dart';

class GetLastOperationsUseCase {
  final LocalRepository repository;
  GetLastOperationsUseCase(this.repository);

  Future<List<Operation>> execute({int count = 0}) async {
    final all = await repository.getOperations();
    if (count == 0 || count >= all.length) {
      return all;
    }
    return all.take(count).toList();
  }
}