import 'package:flutter/material.dart';

class StreakInfoView extends StatelessWidget {
  final Map<DateTime, bool> attendance;

  const StreakInfoView({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final today = DateTime(
      DateTime
          .now()
          .year,
      DateTime
          .now()
          .month,
      DateTime
          .now()
          .day,
    );
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));

    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDays.map((day) {
            final isUpcoming = day.isAfter(today);
            final isActive = attendance[day] == true;
            final isMissed = attendance[day] == false;

            IconData icon;
            Color color;

            if (isUpcoming) {
              icon = Icons.access_time;
              color = Colors.grey;
            } else if (isActive) {
              icon = Icons.local_fire_department;
              color = Colors.orange;
            } else if (isMissed) {
              icon = Icons.warning;
              color = Colors.red;
            } else {
              icon = Icons.help_outline;
              color = Colors.blueGrey;
            }

            return Icon(icon, color: color, size: 40);
          }).toList(),
        )
    );
  }
}
