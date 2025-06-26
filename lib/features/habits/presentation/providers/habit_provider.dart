import 'package:anchor/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:anchor/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:anchor/features/habits/domain/repositories/habit_repository.dart';
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
}
