import 'package:anchor/core/database/database_helper.dart';
import 'package:anchor/features/habits/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HabitRepository {
  Future<void> insertHabit(Habit habit) async {
    final db = await DatabaseHelper.database;
    await db.insert(
        'habits',
        {
          'id': habit.id,
          'title': habit.title,
          'icon_code_point': habit.icon.codePoint,
          'type': habit.type.name,
          'counter': habit.counter,
          'streak': habit.streak,
          'last_done': habit.lastDone?.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('habits');

    return maps
        .map((map) => Habit(
              id: map['id'] as int,
              title: map['title'] as String,
              icon: IconData(map['icon_code_point'] as int,
                  fontFamily: 'MaterialIcons'),
              type: HabitType.values.firstWhere((e) => e.name == map['type']),
              counter: map['counter'] as int,
              streak: map['streak'] as int,
              lastDone: map['last_done'] != null
                  ? DateTime.parse(map['last_done'] as String)
                  : null,
            ))
        .toList();
  }

  Future<Habit?> getHabitById(int id) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('habits', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final map = maps.first;
    return Habit(
      id: map['id'] as int,
      title: map['title'] as String,
      icon:
          IconData(map['icon_code_point'] as int, fontFamily: 'MaterialIcons'),
      type: HabitType.values.firstWhere((e) => e.name == map['type']),
      counter: map['counter'] as int,
      streak: map['streak'] as int,
      lastDone: map['last_done'] != null
          ? DateTime.parse(map['last_done'] as String)
          : null,
    );
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await DatabaseHelper.database;
    await db.update(
        'habits',
        {
          'title': habit.title,
          'icon_code_point': habit.icon.codePoint,
          'type': habit.type.name,
          'counter': habit.counter,
          'streak': habit.streak,
          'last_done': habit.lastDone?.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [habit.id]);
  }

  Future<void> deleteHabit(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
