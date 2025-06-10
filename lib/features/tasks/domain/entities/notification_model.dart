class NotificationModel {
  final int id;
  final String taskId;
  final String triggerType;
  final int triggerValue;
  final DateTime scheduledTime;

  NotificationModel({
    required this.id,
    required this.taskId,
    required this.triggerType,
    required this.triggerValue,
    required this.scheduledTime,
  });

  NotificationModel copyWith({
    int? id,
    String? taskId,
    String? triggerType,
    int? triggerValue,
    DateTime? scheduledTime,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      triggerType: triggerType ?? this.triggerType,
      triggerValue: triggerValue ?? this.triggerValue,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }
}
