import 'package:get_it/get_it.dart';
import '../../data/datasource/shared_prefs_factory.dart';
import '../../data/datasource/local_datasource.dart';
import '../../data/repository/local_repository_impl.dart';
import '../../domain/repository/local_repository.dart';
import '../../domain/usecase/add_operation_usecase.dart';
import '../../domain/usecase/get_operations_usecase.dart';
import '../../domain/usecase/remove_operation_usecase.dart';
import '../../domain/usecase/set_budget_usecase.dart';
import '../../domain/usecase/get_budget_usecase.dart';
import '../../data/service/shared_pref_repository_impl.dart';
import '../../domain/repository/shared_pref_repository.dart';
import '../../domain/usecase/get_streak_info_usecase.dart';
import '../navigation/navigation_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Navigation
  getIt.registerLazySingleton(() => NavigationService());

  // Existing dependencies
  getIt.registerLazySingleton<SharedPrefRepository>(() {
    return SharedPrefRepositoryImpl();
  });

  getIt.registerLazySingleton(() =>
      GetStreakInfoUseCase(getIt<SharedPrefRepository>()));

  // New dependencies
  // Data sources
  getIt.registerLazySingletonAsync<LocalDataSource>(
    () => SharedPrefsFactory.create(),
  );

  // Repositories
  getIt.registerLazySingleton<LocalRepository>(
    () => LocalRepositoryImpl(getIt<LocalDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => AddOperationUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetOperationsUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => RemoveOperationUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => SetBudgetUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetBudgetUseCase(getIt<LocalRepository>()),
  );
}
