import '../../domain/entity/budget.dart';
import '../entity/pet.dart';

abstract class SharedPrefRepository {
  Future<Map<DateTime, bool>> getWeekAttendance();
  Future<void> updateWeekAttendance();
  Future<DateTime?> getStreakStartDate();
  Future<bool> checkTodayAttendance();
  Future<Budget?> getBudget();
  Future<void> setBudget(Budget budget);
  Future<List<String>> getPetColors();
  Future<void> setPetColors(List<String> colors);
  Future<Pet?> getPet();
  Future<void> setPet(Pet pet);
}
