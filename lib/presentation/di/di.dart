import 'package:get_it/get_it.dart';
import 'package:moneytama/domain/usecase/add_expense_category_usecase.dart';
import 'package:moneytama/domain/usecase/add_expense_usecase.dart';
import 'package:moneytama/domain/usecase/add_income_category_usecase.dart';
import 'package:moneytama/domain/usecase/add_income_usecase.dart';

import '../../data/service/shared_pref_repository_impl.dart';
import '../../domain/repository/shared_pref_repository.dart';
import '../../domain/usecase/get_expense_categories_usecase.dart';
import '../../domain/usecase/get_income_categories_usecase.dart';
import '../../domain/usecase/get_streak_info_usecase.dart';
import '../navigation/navigation_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => NavigationService());

  getIt.registerLazySingleton<SharedPrefRepository>(() {
    return SharedPrefRepositoryImpl();
  });

  getIt.registerLazySingleton(() =>
      GetStreakInfoUseCase(getIt<SharedPrefRepository>()));

  getIt.registerLazySingleton(() =>
      AddExpenseCategoryUseCase()
  );
  getIt.registerLazySingleton(() =>
      AddExpenseUseCase()
  );
  getIt.registerLazySingleton(() =>
      AddIncomeCategoryUseCase()
  );
  getIt.registerLazySingleton(() =>
      AddIncomeUseCase()
  );
  getIt.registerLazySingleton(() =>
      GetExpenseCategoriesUseCase()
  );
  getIt.registerLazySingleton(() =>
      GetIncomeCategoriesUseCase()
  );
}
