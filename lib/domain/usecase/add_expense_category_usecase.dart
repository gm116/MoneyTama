import '../entity/category.dart';
import '../repository/local_repository.dart';

class AddExpenseCategoryUseCase {
  final LocalRepository repository;
  AddExpenseCategoryUseCase(this.repository);

  Future<void> execute(String name) async {
    final category = Category(
      name: name,
      type: 'expense',
      isCustom: true,
    );
    await repository.addCategory(category);
  }
}