import '../repository/local_repository.dart';

class RemoveCategoryUseCase {
  final LocalRepository repository;

  RemoveCategoryUseCase(this.repository);

  Future<void> execute(int id) => repository.removeCategory(id);
}
