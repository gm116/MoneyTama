import '../entity/category.dart';
import '../repository/local_repository.dart';

class AddCategoryUseCase {
  final LocalRepository repository;

  AddCategoryUseCase(this.repository);

  Future<void> execute(Category category) => repository.addCategory(category);
}
