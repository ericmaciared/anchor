import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

import 'subtask_list.dart';

class TaskExpandedActions extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onComplete;
  final VoidCallback onUndoComplete;
  final VoidCallback showUndoDialog;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;

  const TaskExpandedActions({
    super.key,
    required this.task,
    required this.onComplete,
    required this.showUndoDialog,
    required this.onUndoComplete,
    required this.onToggleSubtaskCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = (task.color.computeLuminance() < 0.5);
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.subtasks.isNotEmpty)
          SubtaskList(
            subtasks: task.subtasks,
            baseColor: task.color,
            onToggleSubtaskCompletion: (subtask) =>
                onToggleSubtaskCompletion(subtask),
          ),
        const SizedBox(height: 12),
        if (task.isDone)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task completed!',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                ),
              ),
              TextButton(
                onPressed: showUndoDialog,
                child: const Text('Undo'),
              ),
            ],
          )
        else
          GestureDetector(
            onLongPress: onComplete,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: task.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Hold to Complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
