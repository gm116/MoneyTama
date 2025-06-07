import 'package:get_it/get_it.dart';

import '../../data/service/shared_pref_repository_impl.dart';
import '../../domain/repository/shared_pref_repository.dart';
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
}
