import '../repository/local_repository.dart';

class GetExpenseCategoriesUseCase {
  final LocalRepository repository;

  GetExpenseCategoriesUseCase(this.repository);

  Future<List<String>> execute() =>
      repository.getCategories(type: 'expense')
          .then((categories) =>
          categories.map((category) => category.name).toList());
}
