import 'package:anchor/core/database/database_provider.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalDataSource {
  final Ref ref;

  TaskLocalDataSource(this.ref);

  Future<Database> get database async => ref.read(databaseProvider);

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks');

    return maps.map((map) {
      return Task(
        id: map['id'] as String,
        title: map['title'] as String,
        isDone: (map['isDone'] as int) == 1,
        day: DateTime.parse(map['day'] as String),
        startTime: map['startTime'] != null
            ? DateTime.tryParse(map['startTime'] as String)
            : null,
        duration: map['duration'] != null
            ? Duration(minutes: map['duration'] as int)
            : null,
        color: Color(map['color'] as int),
        icon: IconData(
          map['iconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
        parentTaskId: map['parentTaskId'] as String?,
      );
    }).toList();
  }

  Future<void> createTask(Task task) async {
    final db = await database;
    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'isDone': task.isDone ? 1 : 0,
      'day': task.day.toIso8601String(),
      'startTime': task.startTime?.toIso8601String(),
      'duration': task.duration?.inMinutes,
      'color': task.color.toARGB32(),
      'iconCodePoint': task.icon.codePoint,
      'parentTaskId': task.parentTaskId,
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'isDone': task.isDone ? 1 : 0,
        'day': task.day.toIso8601String(),
        'startTime': task.startTime?.toIso8601String(),
        'duration': task.duration?.inMinutes,
        'color': task.color.toARGB32(),
        'iconCodePoint': task.icon.codePoint,
        'parentTaskId': task.parentTaskId,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
