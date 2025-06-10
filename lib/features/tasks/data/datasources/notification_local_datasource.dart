import 'package:anchor/core/database/database_provider.dart';
import 'package:anchor/features/tasks/domain/entities/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class NotificationLocalDataSource {
  final Ref ref;

  NotificationLocalDataSource(this.ref);

  Future<Database> get database async => ref.read(databaseProvider);

  Future<List<NotificationModel>> getNotificationsForTask(String taskId) async {
    final db = await database;
    final maps = await db
        .query('notifications', where: 'taskId = ?', whereArgs: [taskId]);

    return maps.map((map) {
      return NotificationModel(
        id: map['id'] as int,
        taskId: map['taskId'] as String,
        triggerType: map['triggerType'] as String,
        triggerValue: map['triggerValue'] as int,
        scheduledTime:
            DateTime.tryParse(map['scheduledTime'] as String) ?? DateTime.now(),
      );
    }).toList();
  }

  Future<void> createNotification(
      String taskId, NotificationModel entry) async {
    final db = await database;
    await db.insert('notifications', {
      'id': entry.id,
      'taskId': taskId,
      'triggerType': entry.triggerType,
      'triggerValue': entry.triggerValue,
      'scheduledTime': entry.scheduledTime.toIso8601String(),
    });
  }

  Future<void> deleteNotification(String id) async {
    final db = await database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNotificationsForTask(String taskId) async {
    final db = await database;
    await db.delete('notifications', where: 'taskId = ?', whereArgs: [taskId]);
  }
}
