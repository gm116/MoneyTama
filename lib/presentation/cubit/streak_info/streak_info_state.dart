abstract class StreakInfoState {}

class StreakInfoInitial extends StreakInfoState {}

class StreakInfoLoaded extends StreakInfoState {
  final int currentStreak;
  final Map<DateTime, bool> attendance;

  StreakInfoLoaded({
    required this.currentStreak,
    required this.attendance,
  });
}

class StreakInfoSkip extends StreakInfoState {}
