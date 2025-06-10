import 'package:anchor/features/shared/notifications/notification_id_generator.dart';
import 'package:anchor/features/shared/notifications/notification_service.dart';
import 'package:anchor/features/tasks/domain/entities/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.read(notificationServiceProvider);

    void _scheduleNotification() async {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));

      final safeId = await NotificationIdGenerator.next();

      final notification = NotificationModel(
        id: safeId,
        taskId: 'demo-task-id',
        // must be unique per notification
        triggerType: 'test',
        triggerValue: 10,
        scheduledTime: scheduledTime,
      );

      notificationService.scheduleNotification(
          notification, 'Test Title', 'Test subtitle');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Immediate Notification')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => notificationService.showNow(),
              child: const Text('Trigger Notification Now'),
            ),
            ElevatedButton(
              onPressed: () => _scheduleNotification(),
              child: const Text('Schedule Notification in 10 Seconds'),
            ),
          ],
        ),
      ),
    );
  }
}
