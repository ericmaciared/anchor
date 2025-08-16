import 'package:anchor/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:anchor/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:anchor/features/habits/domain/repositories/habit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final habitProvider = StateNotifierProvider<HabitNotifier, List<HabitModel>>(
  (ref) => HabitNotifier(
    repository: HabitRepositoryImpl(HabitLocalDataSource(ref)),
  ),
);

class HabitNotifier extends StateNotifier<List<HabitModel>> {
  final HabitRepository repository;

  HabitNotifier({
    required this.repository,
  }) : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await repository.getAllHabits();
    state = habits;
  }

  Future<void> createHabit(HabitModel habit) async {
    await repository.createHabit(habit);

    state = [...state, habit];
  }

  Future<void> updateHabit(HabitModel updatedHabit) async {
    await repository.updateHabit(updatedHabit);

    state = state.map((habit) {
      return habit.id == updatedHabit.id ? updatedHabit : habit;
    }).toList();
  }

  Future<HabitModel?> deleteHabit(String habitId) async {
    try {
      final habitToDelete = state.firstWhere((habit) => habit.id == habitId);

      await repository.deleteHabit(habitId);
      state = state.where((habit) => habit.id != habitId).toList();

      return habitToDelete;
    } catch (_) {
      return null;
    }
  }

  Future<void> undoDelete(HabitModel habit) async {
    await repository.createHabit(habit);

    state = [...state, habit];
  }

  Future<void> toggleHabitCompletion(HabitModel habit) async {
    final now = DateTime.now();
    HabitModel updatedHabit;

    if (habit.isCompletedToday()) {
      // User is cancelling today's completion
      updatedHabit = _handleCancellation(habit, now);
    } else {
      // User is completing the habit today
      updatedHabit = _handleCompletion(habit, now);
    }

    await repository.updateHabit(updatedHabit);
    state = state.map((h) => h.id == updatedHabit.id ? updatedHabit : h).toList();
  }

  /// Handles when a user marks a habit as complete
  HabitModel _handleCompletion(HabitModel habit, DateTime now) {
    final yesterday = DateUtils.dateOnly(now.subtract(const Duration(days: 1)));

    int newStreak;

    if (habit.lastCompletedDate == null) {
      // First time completing this habit
      newStreak = 1;
    } else {
      final lastCompletedDay = DateUtils.dateOnly(habit.lastCompletedDate!);

      if (lastCompletedDay.isAtSameMomentAs(yesterday)) {
        // Completed yesterday, continue the streak
        newStreak = habit.currentStreak + 1;
      } else {
        // Gap in completion or first completion, start new streak
        newStreak = 1;
      }
    }

    return habit.copyWith(
      lastCompletedDate: now,
      currentStreak: newStreak,
    );
  }

  /// Handles when a user cancels today's completion
  HabitModel _handleCancellation(HabitModel habit, DateTime now) {
    final yesterday = DateUtils.dateOnly(now.subtract(const Duration(days: 1)));

    // Set last completion date to yesterday and subtract 1 from streak
    final newStreak = habit.currentStreak - 1;

    // Create yesterday's completion date (set to end of day to avoid timezone issues)
    final newLastCompletedDate = DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
      23,
      59,
      59,
    );

    return habit.copyWith(
      lastCompletedDate: newLastCompletedDate,
      currentStreak: newStreak > 0 ? newStreak : 0,
    );
  }
}
