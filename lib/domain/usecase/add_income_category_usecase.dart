import '../entity/category.dart';
import '../repository/local_repository.dart';

class AddIncomeCategoryUseCase {
  final LocalRepository repository;
  AddIncomeCategoryUseCase(this.repository);

  Future<void> execute(String name) async {
    final category = Category(
      name: name,
      type: 'income',
      isCustom: true,
    );
    await repository.addCategory(category);
  }
}