import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/task_card.dart';
import 'package:flutter/material.dart';

typedef TaskCallback = void Function(TaskModel task);

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final String? label;
  final void Function(TaskModel task) onToggleTaskCompletion;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;
  final TaskCallback onLongPress;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggleTaskCompletion,
    required this.onToggleSubtaskCompletion,
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
            onToggleTaskCompletion: () => onToggleTaskCompletion(task),
            onLongPress: () => onLongPress(task),
            onToggleSubtaskCompletion: (subtask) =>
                onToggleSubtaskCompletion(subtask),
          ),
        ),
      ],
    );
  }
}
