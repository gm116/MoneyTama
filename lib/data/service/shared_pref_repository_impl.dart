import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/shared_pref_repository.dart';
import '../../tools/logger.dart';
import '../../domain/entity/budget.dart';


class SharedPrefRepositoryImpl implements SharedPrefRepository {
  static const String _attendanceKey = 'week_attendance';
  static const String _streakStartDateKey = 'streak_start_date';


  static const _plannedAmountKey = 'budget_planned_amount';
  static const _plannedPeriodKey = 'budget_planned_period';
  static const _currentBalanceKey = 'budget_current_balance';

  @override
  Future<void> setBudget(Budget budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_plannedAmountKey, budget.plannedAmount);
    await prefs.setString(_plannedPeriodKey, budget.plannedPeriod);
    await prefs.setDouble(_currentBalanceKey, budget.currentBalance);
  }

  @override
  Future<Budget?> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final plannedAmount = prefs.getDouble(_plannedAmountKey);
    final plannedPeriod = prefs.getString(_plannedPeriodKey);
    final currentBalance = prefs.getDouble(_currentBalanceKey);

    if (plannedAmount == null || plannedPeriod == null || currentBalance == null) {
      return null; // Нет сохраненного бюджета
    }

    return Budget(
      plannedAmount: plannedAmount,
      plannedPeriod: plannedPeriod,
      currentBalance: currentBalance,
    );
  }


  @override
  Future<Map<DateTime, bool>> getWeekAttendance() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final attendanceData = sharedPrefs.getString(_attendanceKey);
    final DateTime today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day
    );

    if (attendanceData == null) {
      sharedPrefs.setString(
          _streakStartDateKey,
          _normalizeDate(DateTime.now()).toIso8601String());
      return _initializeCurrentWeek();
    }

    Map<String, dynamic> decodedData = Map<String, dynamic>.from(
        jsonDecode(attendanceData) as Map);

    DateTime? startDate = DateTime.parse(
        sharedPrefs.getString(_streakStartDateKey) ??
            _normalizeDate(DateTime.now()).toIso8601String());

    for (final key in decodedData.keys) {
      if (DateTime.parse(key).isBefore(today)) break;
      if (!(decodedData[key] as bool)) {
        startDate = null;
      } else {
        startDate ??= DateTime.parse(key);
        sharedPrefs.setString(
            _streakStartDateKey,
            startDate.toIso8601String());
      }
    }

    final currentWeekDates = _getCurrentWeekDates();
    logger.info('repo getWeekAttendance: $decodedData');
    return {
      for (var entry in decodedData.entries)
        if (currentWeekDates.contains(DateTime.parse(entry.key)))
          DateTime.parse(entry.key): entry.value as bool
    };
  }

  @override
  Future<void> updateWeekAttendance() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now();
    final currentWeekDates = _getCurrentWeekDates();

    final attendanceData = await getWeekAttendance();

    for (final date in currentWeekDates) {
      attendanceData.putIfAbsent(_normalizeDate(date), () => false);
    }

    attendanceData[_normalizeDate(currentDate)] = true;
    attendanceData.removeWhere((key, value) => !currentWeekDates.contains(key));

    final encodedData = jsonEncode(
        attendanceData.map((key, value) =>
            MapEntry(key.toIso8601String(), value)));
    logger.info('repo updateWeekAttendance: $encodedData');
    await sharedPrefs.setString(_attendanceKey, encodedData);
  }

  @override
  Future<DateTime?> getStreakStartDate() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final startDateString = sharedPrefs.getString(_streakStartDateKey);
    if (startDateString == null) {
      logger.info('repo getStreakStartDate: no start date found');
      return null;
    }
    final startDate = DateTime.tryParse(startDateString);
    if (startDate == null) {
      logger.info('repo getStreakStartDate: invalid start date');
      return null;
    }
    logger.info('repo getStreakStartDate: $startDate');
    return _normalizeDate(startDate);
  }

  @override
  Future<bool> checkTodayAttendance() async {
    final attendanceData = await getWeekAttendance();
    final today = _normalizeDate(DateTime.now());
    logger.info('repo checkTodayAttendance: $today, ${attendanceData[today]}');
    return attendanceData[today] ?? false;
  }

  Future<Map<DateTime, bool>> _initializeCurrentWeek() async {
    final currentWeekDates = _getCurrentWeekDates();
    return {for (final date in currentWeekDates) date: false};
  }

  List<DateTime> _getCurrentWeekDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(
        7, (index) => _normalizeDate(monday.add(Duration(days: index)))
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // for debugging purposes
  Future<void> clear() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.remove(_attendanceKey);
    await sharedPrefs.remove(_streakStartDateKey);
    logger.info('repo clear: SharedPreferences cleared');
  }
}