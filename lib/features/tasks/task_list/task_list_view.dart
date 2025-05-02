import 'package:anchor/features/tasks/models/task_model.dart';
import 'package:anchor/features/tasks/task_card.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task task) onMarkCompleted;
  final Future<void> Function(Task task) onUndoCompleted;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onMarkCompleted,
    required this.onUndoCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (task.completed) {
                onUndoCompleted(task);
              }
            },
            onLongPress: () {
              if (!task.completed) {
                onMarkCompleted(task);
              }
            },
            child: TaskCard(task: task),
          ),
        );
      },
    );
  }
}
