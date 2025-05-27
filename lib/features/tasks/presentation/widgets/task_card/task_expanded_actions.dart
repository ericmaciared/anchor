import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';

import 'subtask_list.dart';

class TaskExpandedActions extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onUndoComplete;
  final VoidCallback showUndoDialog;

  const TaskExpandedActions({
    super.key,
    required this.task,
    required this.onComplete,
    required this.showUndoDialog,
    this.onUndoComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = (task.color.computeLuminance() < 0.5);
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.subtasks.isNotEmpty)
          SubtaskList(subtasks: task.subtasks, baseColor: task.color),
        const SizedBox(height: 12),
        if (task.isDone && onUndoComplete != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Task completed!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: showUndoDialog,
                child: const Text('Undo'),
              ),
            ],
          )
        else if (task.isDone)
          const Text(
            'Task completed!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          )
        else
          GestureDetector(
            onLongPress: onComplete,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: task.color,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                'Hold to Complete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
