import 'package:anchor/features/tasks/domain/entities/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database and set default location
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Madrid'));

    // Notification settings for Android and iOS
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// Schedule a notification using the provided NotificationModel
  Future<void> scheduleNotification(
      NotificationModel notification, String title, String subtitle) async {
    final scheduledTime =
        tz.TZDateTime.from(notification.scheduledTime, tz.local);

    if (scheduledTime.isAfter(tz.TZDateTime.now(tz.local))) {
      const androidDetails = AndroidNotificationDetails(
        'scheduled_channel_id',
        'Scheduled',
        channelDescription: 'Scheduled task reminders',
        importance: Importance.max,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      var safeId = notification.id;
      await flutterLocalNotificationsPlugin.zonedSchedule(
        safeId,
        title,
        subtitle,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  /// Immediately show a local notification (optional helper)
  Future<void> showNow({
    String title = 'Immediate Notification',
    String body = 'This notification was shown instantly.',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Use a fixed ID for immediate notifications
      title,
      body,
      details,
    );
  }

  /// Cancel a specific notification by its ID
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all scheduled notifications (optional helper)
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
