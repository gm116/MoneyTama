import '../entity/category.dart';
import '../repository/local_repository.dart';

class GetExpenseCategoriesUseCase {
  final LocalRepository repository;

  GetExpenseCategoriesUseCase(this.repository);

  Future<List<Category>> execute() => repository.getCategories(type: 'expense');
}
