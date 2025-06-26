import 'package:anchor/core/database/database_provider.dart';
import 'package:anchor/features/habits/domain/entities/habit_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class HabitLocalDataSource {
  final Ref ref;

  HabitLocalDataSource(this.ref);

  Future<Database> get database async => ref.read(databaseProvider);

  Future<List<HabitModel>> getAllHabits() async {
    final db = await database;

    final habitMaps = await db.query('habits');
    final List<HabitModel> habits = [];

    for (final map in habitMaps) {
      final habit = HabitModel(
        id: map['id'] as String,
        name: map['name'] as String,
        isSelected: (map['isSelected'] as int) == 1,
        isCustom: (map['isCustom'] as int) == 1,
        currentStreak: map['currentStreak'] as int,
        lastCompletedDate: map['lastCompletedDate'] != null
            ? DateTime.parse(map['lastCompletedDate'] as String)
            : null,
      );

      habits.add(habit);
    }

    return habits;
  }

  Future<void> createHabit(HabitModel habit) async {
    final db = await database;

    await db.insert('tasks', {
      'id': habit.id,
      'name': habit.name,
      'isSelected': habit.isSelected ? 1 : 0,
      'isCustom': habit.isCustom ? 1 : 0,
      'currentStreak': habit.currentStreak,
      'lastCompletedDate': habit.lastCompletedDate?.toIso8601String(),
    });
  }

  Future<void> updateHabit(HabitModel habit) async {
    final db = await database;

    await db.update(
      'tasks',
      {
        'id': habit.id,
        'name': habit.name,
        'isSelected': habit.isSelected ? 1 : 0,
        'isCustom': habit.isCustom ? 1 : 0,
        'currentStreak': habit.currentStreak,
        'lastCompletedDate': habit.lastCompletedDate?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(String id) async {
    final db = await database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
