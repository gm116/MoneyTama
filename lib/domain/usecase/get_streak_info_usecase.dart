import '../entity/streak_info.dart';
import '../repository/shared_pref_repository.dart';

class GetStreakInfoUseCase {
  final SharedPrefRepository _sharedPrefRepository;

  GetStreakInfoUseCase(this._sharedPrefRepository);

  Future<StreakInfo?> execute() async {
    final visitedToday = await _sharedPrefRepository.checkTodayAttendance();
    if (visitedToday) {
      // no need to show attendance for today
      return null;
    }

    // first visit today, update the attendance
    await _sharedPrefRepository.updateWeekAttendance();

    final attendance = await _sharedPrefRepository.getWeekAttendance();
    final startDate = await _sharedPrefRepository.getStreakStartDate();
    return StreakInfo(
      attendance: attendance,
      startDate: startDate ?? DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      )
    );
  }
}
