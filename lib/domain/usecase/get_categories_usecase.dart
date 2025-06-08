import '../entity/category.dart';
import '../repository/local_repository.dart';

class GetCategoriesUseCase {
  final LocalRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> execute({String? type}) =>
      repository.getCategories(type: type);
}
