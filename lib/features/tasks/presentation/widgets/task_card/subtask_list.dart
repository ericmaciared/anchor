import 'package:anchor/features/tasks/domain/entities/subtask.dart';
import 'package:flutter/material.dart';

class SubtaskList extends StatelessWidget {
  final List<Subtask> subtasks;
  final Color baseColor;
  final void Function(Subtask) onToggleSubtaskCompletion;

  const SubtaskList({
    super.key,
    required this.subtasks,
    required this.baseColor,
    required this.onToggleSubtaskCompletion,
  });

  @override
  Widget build(BuildContext context) {
    if (subtasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Subtasks',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...subtasks.map((subtask) => GestureDetector(
              onTap: () => onToggleSubtaskCompletion(subtask),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                          decoration: subtask.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
