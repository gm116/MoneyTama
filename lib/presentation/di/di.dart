import 'package:get_it/get_it.dart';

import '../../data/service/shared_pref_repository_impl.dart';
import '../../domain/repository/shared_pref_repository.dart';
import '../../domain/usecase/get_streak_info_usecase.dart';
import '../../data/service/local_repository_sqflite_impl.dart';
import '../../domain/repository/local_repository.dart';
import '../../domain/usecase/add_operation_usecase.dart';
import '../../domain/usecase/get_operations_usecase.dart';
import '../../domain/usecase/remove_operation_usecase.dart';
import '../../domain/usecase/set_budget_usecase.dart';
import '../../domain/usecase/get_budget_usecase.dart';
import '../../domain/usecase/add_category_usecase.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/remove_category_usecase.dart';

import '../navigation/navigation_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Навигация
  getIt.registerLazySingleton(() => NavigationService());

  getIt.registerLazySingleton(
    () => GetStreakInfoUseCase(getIt<SharedPrefRepository>()),
  );

  // Новое (sqflite)
  getIt.registerLazySingleton<LocalRepository>(
    () => LocalRepositorySqfliteImpl(),
  );

  // Операции
  getIt.registerLazySingleton(
    () => AddOperationUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetOperationsUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => RemoveOperationUseCase(getIt<LocalRepository>()),
  );

  // Бюджет
  getIt.registerLazySingleton(() => SetBudgetUseCase(getIt<LocalRepository>()));
  getIt.registerLazySingleton(() => GetBudgetUseCase(getIt<LocalRepository>()));

  // Категории
  getIt.registerLazySingleton(
    () => AddCategoryUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCategoriesUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton(
    () => RemoveCategoryUseCase(getIt<LocalRepository>()),
  );
}
