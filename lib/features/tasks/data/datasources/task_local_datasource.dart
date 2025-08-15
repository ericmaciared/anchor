import 'package:anchor/core/database/database_provider.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'notification_local_datasource.dart';
import 'subtask_local_datasource.dart';

class TaskLocalDataSource {
  final Ref ref;

  TaskLocalDataSource(this.ref);

  Future<Database> get database async => ref.read(databaseProvider.future);

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final subtaskDataSource = SubtaskLocalDataSource(ref);
    final notificationDataSource = NotificationLocalDataSource(ref);

    final taskMaps = await db.query('tasks');
    final List<TaskModel> tasks = [];

    for (final map in taskMaps) {
      final taskId = map['id'] as String;

      final subtasks = await subtaskDataSource.getSubtasksForTask(taskId);
      final notifications = await notificationDataSource.getNotificationsForTask(taskId);

      final task = TaskModel(
        id: taskId,
        title: map['title'] as String,
        isDone: (map['isDone'] as int) == 1,
        day: DateTime.parse(map['day'] as String),
        startTime: map['startTime'] != null ? DateTime.tryParse(map['startTime'] as String) : null,
        duration: map['duration'] != null ? Duration(minutes: map['duration'] as int) : null,
        color: Color(map['color'] as int),
        icon: IconData(
          map['iconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
        subtasks: subtasks,
        notifications: notifications,
      );

      tasks.add(task);
    }

    return tasks;
  }

  Future<void> createTask(TaskModel task) async {
    final db = await database;
    final subtaskDataSource = SubtaskLocalDataSource(ref);
    final notificationDataSource = NotificationLocalDataSource(ref);

    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'isDone': task.isDone ? 1 : 0,
      'day': task.day.toIso8601String(),
      'startTime': task.startTime?.toIso8601String(),
      'duration': task.duration?.inMinutes,
      'color': task.color.toARGB32(),
      'iconCodePoint': task.icon.codePoint,
    });

    for (final subtask in task.subtasks) {
      await subtaskDataSource.createSubtask(task.id, subtask);
    }

    for (final notification in task.notifications) {
      await notificationDataSource.createNotification(task.id, notification);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    final subtaskDataSource = SubtaskLocalDataSource(ref);
    final notificationDataSource = NotificationLocalDataSource(ref);

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
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    await subtaskDataSource.deleteSubtasksForTask(task.id);
    for (final subtask in task.subtasks) {
      await subtaskDataSource.createSubtask(task.id, subtask);
    }

    await notificationDataSource.deleteNotificationsForTask(task.id);
    for (final notification in task.notifications) {
      await notificationDataSource.createNotification(task.id, notification);
    }
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
