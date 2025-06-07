import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/cubit/streak_info/streak_info_state.dart';
import 'package:moneytama/tools/logger.dart';

import '../../../domain/usecase/get_streak_info_usecase.dart';

class StreakInfoCubit extends Cubit<StreakInfoState> {
  final GetStreakInfoUseCase getStreakInfoUseCase;

  StreakInfoCubit(this.getStreakInfoUseCase): super(StreakInfoInitial()) {
    logger.info('cubit: StreakInfoCubit initialized');
    loadStreakInfo();
  }

  Future<void> loadStreakInfo() async {
    try {
      logger.info('cubit: loading streak info');
      final streakInfo = await getStreakInfoUseCase.execute();
      if (streakInfo == null) {
        logger.info('cubit: streak info is null, skipping');
        emit(StreakInfoSkip());
        return;
      }
      logger.info('cubit: loaded streak info: $streakInfo');
      emit(StreakInfoLoaded(
        attendance: streakInfo.attendance,
        currentStreak: DateTime.now().difference(streakInfo.startDate).inDays + 1,
      )
      );
    } catch (error) {
      logger.severe(error);
      emit(StreakInfoSkip());
    }
  }
}
