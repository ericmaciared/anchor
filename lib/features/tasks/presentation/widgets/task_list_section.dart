import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_list.dart';
import 'package:flutter/material.dart';

class TaskListSection extends StatelessWidget {
  final List<Task> selectedDayTasks;
  final void Function(Task task) onComplete;
  final void Function(Task task) onLongPress;

  const TaskListSection({
    super.key,
    required this.selectedDayTasks,
    required this.onComplete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheduledTasks = selectedDayTasks
        .where((t) => t.startTime != null)
        .toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

    final unscheduledTasks =
        selectedDayTasks.where((t) => t.startTime == null).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TaskList(
          tasks: unscheduledTasks,
          label: 'Unscheduled Tasks',
          onComplete: onComplete,
          onLongPress: onLongPress,
        ),
        TaskList(
          tasks: scheduledTasks,
          label: 'Scheduled Tasks',
          onComplete: onComplete,
          onLongPress: onLongPress,
        ),
      ],
    );
  }
}
