import 'package:moneytama/tools/logger.dart';

import '../../domain/repository/example_repository.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  @override
  Future<void> doSomething({String text = ''}) {
    logger.info('ExampleRepositoryImpl: $text');
    return Future.delayed(const Duration(seconds: 1));
  }
}
