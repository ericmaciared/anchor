import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String name;
  bool isSelected;
  bool isCustom;
  int currentStreak;
  DateTime? lastCompletedDate;

  HabitModel({
    required this.id,
    required this.name,
    this.isSelected = true,
    this.isCustom = false,
    this.currentStreak = 0,
    this.lastCompletedDate,
  });

  HabitModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
    bool? isCustom,
    int? currentStreak,
    DateTime? lastCompletedDate,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      isCustom: isCustom ?? this.isCustom,
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  /// Checks if the habit was completed today
  bool isCompletedToday() {
    if (lastCompletedDate == null) {
      return false;
    }
    final now = DateTime.now();
    return lastCompletedDate!.year == now.year &&
        lastCompletedDate!.month == now.month &&
        lastCompletedDate!.day == now.day;
  }

  /// Checks if the habit should show a streak (completed today or yesterday)
  bool shouldShowStreak() {
    if (currentStreak <= 0 || lastCompletedDate == null) {
      return false;
    }

    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final yesterday = DateUtils.dateOnly(now.subtract(const Duration(days: 1)));
    final completedDay = DateUtils.dateOnly(lastCompletedDate!);

    return completedDay.isAtSameMomentAs(today) || completedDay.isAtSameMomentAs(yesterday);
  }
}
