import 'package:flutter/material.dart';

enum HabitType { predefined, custom }

class Habit {
  final int id;
  final String title;
  final IconData icon;
  final HabitType type;
  int counter;
  int streak;
  DateTime? lastDone;

  Habit({
    required this.id,
    required this.title,
    required this.icon,
    this.type = HabitType.predefined,
    this.counter = 0,
    this.streak = 0,
    this.lastDone,
  });

  void markDone() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastDone != null) {
      final lastDate = DateTime(lastDone!.year, lastDone!.month, lastDone!.day);

      if (todayDate.difference(lastDate).inDays == 1) {
        streak++;
      } else if (todayDate.isAtSameMomentAs(lastDate)) {
        // already counted today
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    counter++;
    lastDone = today;
  }

  bool isCompletedToday() {
    if (lastDone == null) return false;
    final now = DateTime.now();
    return lastDone!.year == now.year &&
        lastDone!.month == now.month &&
        lastDone!.day == now.day;
  }
}
