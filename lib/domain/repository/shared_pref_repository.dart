import '../../domain/entity/budget.dart';

abstract class SharedPrefRepository {
  Future<Map<DateTime, bool>> getWeekAttendance();
  Future<void> updateWeekAttendance();
  Future<DateTime?> getStreakStartDate();
  Future<bool> checkTodayAttendance();
  Future<Budget?> getBudget();
  Future<void> setBudget(Budget budget);
  Future<List<String>> getPetColors();
  Future<void> setPetColors(List<String> colors);
}
