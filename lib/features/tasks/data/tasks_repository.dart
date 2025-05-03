import 'package:anchor/core/database/database_helper.dart';
import 'package:anchor/features/tasks/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepository {
  Future<void> insertTask(Task task) async {
    final db = await DatabaseHelper.database;
    await db.insert(
        'tasks',
        {
          'id': task.id,
          'title': task.title,
          'category': task.category,
          'start_time': formatTimeOfDay(task.startTime),
          'duration_minutes': task.duration.inMinutes,
          'icon_code_point': task.icon?.codePoint,
          'completed': task.completed ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getAllTasks() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('tasks');

    return maps.map((map) {
      return Task(
        id: map['id'] as int,
        title: map['title'] as String,
        category: map['category'] as String,
        startTime: parseTimeOfDay(map['start_time'] as String),
        duration: Duration(minutes: map['duration_minutes'] as int),
        icon: map['icon_code_point'] != null
            ? IconData(map['icon_code_point'] as int,
                fontFamily: 'MaterialIcons')
            : null,
        completed: (map['completed'] as int) == 1,
      );
    }).toList();
  }

  Future<Task?> getTaskById(int id) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final map = maps.first;
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      category: map['category'] as String,
      startTime: parseTimeOfDay(map['start_time'] as String),
      duration: Duration(minutes: map['duration_minutes'] as int),
      icon: map['icon_code_point'] != null
          ? IconData(map['icon_code_point'] as int, fontFamily: 'MaterialIcons')
          : null,
      completed: (map['completed'] as int) == 1,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await DatabaseHelper.database;
    await db.update(
        'tasks',
        {
          'title': task.title,
          'category': task.category,
          'start_time': formatTimeOfDay(task.startTime),
          'duration_minutes': task.duration.inMinutes,
          'icon_code_point': task.icon?.codePoint,
          'completed': task.completed ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

TimeOfDay parseTimeOfDay(String timeString) {
  final parts = timeString.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}
