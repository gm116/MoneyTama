abstract class StreakState {}

class StreakInitial extends StreakState {}

class StreakLoaded extends StreakState {
  final int currentStreak;
  final Map<DateTime, bool> attendance;

  StreakLoaded({
    required this.currentStreak,
    required this.attendance,
  });
}

class StreakSkip extends StreakState {}
