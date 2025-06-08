import 'package:moneytama/domain/entity/operation.dart';

import '../repository/local_repository.dart';

class RemoveOperationUseCase {
  final LocalRepository repository;

  RemoveOperationUseCase(this.repository);

  Future<void> execute(Operation operation) => repository.removeOperation(operation);
}
