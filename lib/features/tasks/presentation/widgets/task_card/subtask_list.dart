import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';

class SubtaskList extends StatelessWidget {
  final List<Task> subtasks;
  final Color baseColor;

  const SubtaskList(
      {super.key, required this.subtasks, required this.baseColor});

  @override
  Widget build(BuildContext context) {
    if (subtasks.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subtasks',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          ...subtasks.map((subtask) => Row(
                children: [
                  Icon(
                    subtask.isDone
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: subtask.isDone ? Colors.grey : baseColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subtask.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtask.isDone ? Colors.grey : null,
                        decoration:
                            subtask.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
