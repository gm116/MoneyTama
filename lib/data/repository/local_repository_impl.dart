import '../../domain/entity/operation.dart';
import '../../domain/entity/budget.dart';
import '../../domain/repository/local_repository.dart';
import '../datasource/local_datasource.dart';

class LocalRepositoryImpl implements LocalRepository {
  final LocalDataSource _dataSource;

  LocalRepositoryImpl(this._dataSource);

  @override
  Future<void> addOperation(Operation operation) async {
    await _dataSource.saveOperation(operation);
  }

  @override
  Future<List<Operation>> getOperations() async {
    return await _dataSource.getOperations();
  }

  @override
  Future<void> removeOperation(String id) async {
    await _dataSource.deleteOperation(id);
  }

  @override
  Future<void> setBudget(Budget budget) async {
    await _dataSource.saveBudget(budget);
  }

  @override
  Future<Budget?> getBudget() async {
    return await _dataSource.getBudget();
  }
} 