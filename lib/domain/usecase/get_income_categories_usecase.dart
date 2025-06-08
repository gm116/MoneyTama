import '../entity/category.dart';
import '../repository/local_repository.dart';

class GetIncomeCategoriesUseCase {
  final LocalRepository repository;

  GetIncomeCategoriesUseCase(this.repository);

  Future<List<Category>> execute() => repository.getCategories(type: 'income');
}
