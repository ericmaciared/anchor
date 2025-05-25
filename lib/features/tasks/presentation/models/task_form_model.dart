import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'subtask_form_model.dart';

class TaskFormModel {
  final String id;
  String title;
  IconData icon;
  Color color;
  TimeOfDay? selectedTime;
  int? durationMinutes;
  bool isDone;
  DateTime day;
  String? parentTaskId;
  final List<SubtaskFormModel> subtasks;

  TaskFormModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.day,
    this.selectedTime,
    this.durationMinutes,
    this.isDone = false,
    this.parentTaskId,
    this.subtasks = const [],
  });

  factory TaskFormModel.empty({DateTime? day}) {
    return TaskFormModel(
      id: const Uuid().v4(),
      title: '',
      icon: Icons.check_circle_outline,
      color: Colors.blue,
      day: day ?? DateTime.now(),
      subtasks: [],
    );
  }

  factory TaskFormModel.fromTask(Task task) {
    return TaskFormModel(
      id: task.id,
      title: task.title,
      icon: task.icon,
      color: task.color,
      day: task.day,
      selectedTime: task.startTime != null
          ? TimeOfDay.fromDateTime(task.startTime!)
          : null,
      durationMinutes: task.duration?.inMinutes,
      isDone: task.isDone,
      parentTaskId: task.parentTaskId,
      subtasks: [],
    );
  }

  Task toTask() {
    final now = DateTime.now();
    final startTime = selectedTime != null
        ? DateTime(now.year, now.month, now.day, selectedTime!.hour,
            selectedTime!.minute)
        : null;

    return Task(
      id: id,
      title: title.trim(),
      isDone: isDone,
      day: day,
      startTime: startTime,
      duration:
          durationMinutes != null ? Duration(minutes: durationMinutes!) : null,
      color: color,
      icon: icon,
      parentTaskId: parentTaskId,
    );
  }

  bool get isValid => title.trim().isNotEmpty;
}
