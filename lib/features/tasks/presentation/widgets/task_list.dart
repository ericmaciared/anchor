import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:flutter/material.dart';

typedef TaskCallback = void Function(Task task);

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String? label;
  final TaskCallback onComplete;
  final TaskCallback onLongPress;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onComplete,
    required this.onLongPress,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ...tasks.map(
          (task) => TaskCard(
            task: task,
            onComplete: () => onComplete(task),
            onLongPress: () => onLongPress(task),
            onUndoComplete: () => onComplete(task),
          ),
        ),
      ],
    );
  }
}
