import '../repository/local_repository.dart';

class GetIncomeCategoriesUseCase {
  final LocalRepository repository;

  GetIncomeCategoriesUseCase(this.repository);

  Future<List<String>> execute() =>
      repository.getCategories(type: 'income').then((categories) =>
          categories.map((category) => category.name).toList());
}
