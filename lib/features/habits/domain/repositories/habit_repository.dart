import 'package:anchor/features/habits/domain/entities/habit_model.dart';

abstract class HabitRepository {
  Future<List<HabitModel>> getAllHabits();

  Future<void> createHabit(HabitModel habit);

  Future<void> updateHabit(HabitModel habit);

  Future<void> deleteHabit(String id);
}
