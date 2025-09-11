// lib/features/tasks/presentation/widgets/task_card/minimal_task_card.dart

import 'package:anchor/core/services/haptic_feedback_service.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/core/widgets/adaptive_card_widget.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

import 'minimal_task_time_column.dart';

class MinimalTaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onLongPress;
  final VoidCallback onToggleTaskCompletion;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;

  const MinimalTaskCard({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.onToggleTaskCompletion,
    required this.onToggleSubtaskCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MinimalTaskTimeColumn(startTime: task.startTime, duration: task.duration),
                  const SizedBox(width: 8),
                  // Main task card
                  AdaptiveCardWidget(
                    borderRadius: 12,
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        // Add haptic feedback for task completion toggle
                        if (task.isDone) {
                          HapticService.medium(); // Undoing completion
                        } else {
                          HapticService.success(); // Completing task
                        }
                        onToggleTaskCompletion();
                      },
                      onLongPress: () {
                        HapticService.longPress(); // Long press feedback
                        onLongPress();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: task.isDone ? context.colors.onSurface.withAlpha(100) : null,
                          fontSize: TextSizes.m,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Subtasks section
              if (task.subtasks.isNotEmpty)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: task.subtasks.map((subtask) {
                          return GestureDetector(
                            onTap: () {
                              // Add haptic feedback for subtask toggle
                              HapticService.light();
                              onToggleSubtaskCompletion(subtask);
                            },
                            child: Text(
                              subtask.title,
                              style: context.textStyles.bodySmall?.copyWith(
                                decoration: subtask.isDone ? TextDecoration.lineThrough : null,
                                color: subtask.isDone ? context.colors.onSurface.withAlpha(100) : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
