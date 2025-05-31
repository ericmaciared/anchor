import 'package:anchor/core/database/database_provider.dart';
import 'package:anchor/features/tasks/domain/entities/subtask.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class SubtaskLocalDataSource {
  final Ref ref;

  SubtaskLocalDataSource(this.ref);

  Future<Database> get database async => ref.read(databaseProvider);

  Future<List<Subtask>> getSubtasksForTask(String taskId) async {
    final db = await database;
    final maps =
        await db.query('subtasks', where: 'taskId = ?', whereArgs: [taskId]);

    return maps.map((map) {
      return Subtask(
        id: map['id'] as String,
        taskId: map['taskId'] as String,
        title: map['title'] as String,
        isDone: (map['isDone'] as int) == 1,
      );
    }).toList();
  }

  Future<void> createSubtask(String taskId, Subtask subtask) async {
    final db = await database;
    await db.insert('subtasks', {
      'id': subtask.id,
      'taskId': taskId,
      'title': subtask.title,
      'isDone': subtask.isDone ? 1 : 0,
    });
  }

  Future<void> updateSubtask(Subtask subtask) async {
    final db = await database;
    await db.update(
      'subtasks',
      {
        'title': subtask.title,
        'isDone': subtask.isDone ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [subtask.id],
    );
  }

  Future<void> deleteSubtask(String subtaskId) async {
    final db = await database;
    await db.delete('subtasks', where: 'id = ?', whereArgs: [subtaskId]);
  }

  Future<void> deleteSubtasksForTask(String taskId) async {
    final db = await database;
    await db.delete('subtasks', where: 'taskId = ?', whereArgs: [taskId]);
  }
}
