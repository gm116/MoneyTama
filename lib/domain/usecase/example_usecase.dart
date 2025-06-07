import '../repository/example_repository.dart';

class ExampleUseCase {
  final ExampleRepository _exampleRepository;
  ExampleUseCase(this._exampleRepository);

  Future<void> execute() async {
    await _exampleRepository.doSomething(
      text: 'doing something',
    );
  }
}
