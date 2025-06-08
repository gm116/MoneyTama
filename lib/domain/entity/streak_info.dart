class StreakInfo {
  final DateTime startDate;
  final Map<DateTime, bool> attendance;

  StreakInfo({
    required this.startDate,
    required this.attendance,
  });

  @override
  String toString() {
    return 'StreakInfo(startDate: $startDate, attendance: $attendance)';
  }
}
