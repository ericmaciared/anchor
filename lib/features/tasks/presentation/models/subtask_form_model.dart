import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SubtaskFormModel {
  String title;
  bool isDone;

  SubtaskFormModel({this.title = '', this.isDone = false});

  bool get isValid => title.trim().isNotEmpty;

  Task toTask(String parentTaskId) {
    return Task(
      id: const Uuid().v4(),
      title: title.trim(),
      isDone: isDone,
      day: DateTime.now(),
      color: Colors.blue,
      icon: Icons.check_circle_outline,
      parentTaskId: parentTaskId,
    );
  }
}
