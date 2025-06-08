import 'package:get_it/get_it.dart';
import 'package:moneytama/domain/usecase/get_expense_categories_usecase.dart';
import 'package:moneytama/domain/usecase/add_expense_usecase.dart';
import 'package:moneytama/domain/usecase/get_income_categories_usecase.dart';
import 'package:moneytama/domain/usecase/add_income_usecase.dart';
import 'package:moneytama/domain/usecase/set_pet_colors_usecase.dart';

import '../../data/service/shared_pref_repository_impl.dart';
import '../../domain/repository/shared_pref_repository.dart';
import '../../domain/usecase/add_expense_category_usecase.dart';
import '../../domain/usecase/add_income_category_usecase.dart';
import '../../domain/usecase/get_last_operations_usecase.dart';
import '../../domain/usecase/get_pet_colors_usecase.dart';
import '../../domain/usecase/get_streak_info_usecase.dart';

import '../../domain/usecase/get_budget_usecase.dart';
import '../../domain/usecase/set_budget_usecase.dart';
import '../../domain/usecase/remove_category_usecase.dart';
import '../../domain/usecase/remove_operation_usecase.dart';

import '../../data/service/local_repository_sqflite_impl.dart';
import '../../domain/repository/local_repository.dart';

import '../navigation/navigation_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => NavigationService());

  getIt.registerLazySingleton<SharedPrefRepository>(() => SharedPrefRepositoryImpl());
  getIt.registerLazySingleton(() => GetStreakInfoUseCase(getIt<SharedPrefRepository>()));

  // Репозиторий для sqflite — для всех юзкейсов ниже
  getIt.registerLazySingleton<LocalRepository>(() => LocalRepositorySqfliteImpl());

  getIt.registerLazySingleton(() => AddExpenseCategoryUseCase(getIt<LocalRepository>()));
  getIt.registerLazySingleton(() => AddExpenseUseCase(getIt<LocalRepository>(), getIt<SharedPrefRepository>()));
  getIt.registerLazySingleton(() => AddIncomeCategoryUseCase(getIt<LocalRepository>()));
  getIt.registerLazySingleton(() => AddIncomeUseCase(getIt<LocalRepository>(), getIt<SharedPrefRepository>()));
  getIt.registerLazySingleton(() => GetExpenseCategoriesUseCase(getIt<LocalRepository>()));
  getIt.registerLazySingleton(() => GetIncomeCategoriesUseCase(getIt<LocalRepository>()));
  getIt.registerLazySingleton(() => GetLastOperationsUseCase(getIt<LocalRepository>()));

  // Бюджет и удаление
  getIt.registerLazySingleton(() => SetBudgetUseCase(getIt<SharedPrefRepository>()));
  getIt.registerLazySingleton(() => GetBudgetUseCase(getIt<SharedPrefRepository>()));
  getIt.registerLazySingleton(() => RemoveCategoryUseCase(getIt<LocalRepository>()));
  getIt.registerLazySingleton(() => RemoveOperationUseCase(getIt<LocalRepository>(), getIt<SharedPrefRepository>()));

  getIt.registerLazySingleton(() => GetPetColorsUseCase(getIt<SharedPrefRepository>()));
  getIt.registerLazySingleton(() => SetPetColorsUseCase(getIt<SharedPrefRepository>()));
}
