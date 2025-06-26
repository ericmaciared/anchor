import 'package:anchor/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:anchor/features/habits/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource habitLocalDataSource;

  HabitRepositoryImpl(this.habitLocalDataSource);

  @override
  Future<List<HabitModel>> getAllHabits() {
    return habitLocalDataSource.getAllHabits();
  }

  @override
  Future<void> createHabit(HabitModel habit) {
    return habitLocalDataSource.createHabit(habit);
  }

  @override
  Future<void> updateHabit(HabitModel habit) {
    return habitLocalDataSource.updateHabit(habit);
  }

  @override
  Future<void> deleteHabit(String id) {
    return habitLocalDataSource.deleteHabit(id);
  }
}
