import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/cubit/streak/streak_state.dart';
import 'package:moneytama/tools/logger.dart';

import '../../../domain/usecase/get_streak_info_usecase.dart';

class StreakCubit extends Cubit<StreakState> {
  final GetStreakInfoUseCase getStreakInfoUseCase;

  StreakCubit(this.getStreakInfoUseCase): super(StreakInitial()) {
    logger.info('cubit: StreakInfoCubit initialized');
    loadStreakInfo();
  }

  Future<void> loadStreakInfo() async {
    try {
      logger.info('cubit: loading streak info');
      final streakInfo = await getStreakInfoUseCase.execute();
      if (streakInfo == null) {
        logger.info('cubit: streak info is null, skipping');
        emit(StreakSkip());
        return;
      }
      logger.info('cubit: loaded streak info: $streakInfo');
      emit(StreakLoaded(
        attendance: streakInfo.attendance,
        currentStreak: DateTime.now().difference(streakInfo.startDate).inDays + 1,
      )
      );
    } catch (error) {
      logger.severe(error);
      emit(StreakSkip());
    }
  }
}
