abstract class SharedPrefRepository {
  Future<Map<DateTime, bool>> getWeekAttendance();
  Future<void> updateWeekAttendance();
  Future<DateTime?> getStreakStartDate();
  Future<bool> checkTodayAttendance();
}
