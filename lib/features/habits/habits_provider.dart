import 'package:anchor/features/habits/data/habits_repository.dart';
import 'package:anchor/features/habits/models/habit_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final habitRepositoryProvider =
    Provider<HabitRepository>((ref) => HabitRepository());

final habitListProvider = FutureProvider<List<Habit>>((ref) async {
  final repo = ref.watch(habitRepositoryProvider);
  return repo.getAllHabits();
});
