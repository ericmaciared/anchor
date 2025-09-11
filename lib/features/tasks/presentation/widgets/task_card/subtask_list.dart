import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:flutter/material.dart';

class SubtaskList extends StatelessWidget {
  final List<SubtaskModel> subtasks;
  final Color baseColor;
  final void Function(SubtaskModel) onToggleSubtaskCompletion;

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
        Text(
          'Subtasks',
          style: TextStyle(
            fontSize: TextSizes.m,
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface.withAlpha(100),
          ),
        ),
        const SizedBox(height: 8),
        ...subtasks.map((subtask) => GestureDetector(
              onTap: () {
                // Add haptic feedback for subtask toggle
                if (subtask.isDone) {
                  HapticService.light(); // Light feedback for unchecking
                } else {
                  HapticService.medium(); // Medium feedback for checking
                }
                onToggleSubtaskCompletion(subtask);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      subtask.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 18,
                      color: subtask.isDone ? context.colors.onSurface.withAlpha(100) : baseColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        subtask.title,
                        style: TextStyle(
                          fontSize: TextSizes.m,
                          color: subtask.isDone ? context.colors.onSurface.withAlpha(100) : null,
                          decoration: subtask.isDone ? TextDecoration.lineThrough : null,
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
