import 'package:anchor/features/tasks/domain/entities/notification_model.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isDone;
  final DateTime day;
  final DateTime? startTime;
  final Duration? duration;
  final Color color;
  final IconData icon;
  final List<SubtaskModel> subtasks;
  final List<NotificationModel> notifications;

  TaskModel({
    required this.id,
    required this.title,
    required this.isDone,
    required this.day,
    this.startTime,
    this.duration,
    required this.color,
    required this.icon,
    this.subtasks = const [],
    this.notifications = const [],
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? day,
    DateTime? startTime,
    bool clearStartTime = false,
    Duration? duration,
    bool clearDuration = false,
    Color? color,
    IconData? icon,
    List<SubtaskModel>? subtasks,
    List<NotificationModel>? notifications,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      day: day ?? this.day,
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      duration: clearDuration ? null : (duration ?? this.duration),
      color: color ?? this.color,
      icon: icon ?? this.icon,
      subtasks: subtasks ?? this.subtasks,
      notifications: notifications ?? this.notifications,
    );
  }
}
