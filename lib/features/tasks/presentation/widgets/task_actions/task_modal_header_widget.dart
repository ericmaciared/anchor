// File: lib/features/tasks/presentation/widgets/task_actions/task_modal_header.dart

import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

class TaskModalHeader extends StatelessWidget {
  final TaskModel task;
  final bool isEdit;

  const TaskModalHeader({
    super.key,
    required this.task,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: context.colors.onSurface.withAlpha(50),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 24),

        // Header with icon and title
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: task.color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(task.icon, color: task.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                isEdit ? 'Edit Task' : 'New Task',
                style: context.textStyles.headlineMedium!.copyWith(
                  fontSize: TextSizes.XXL,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
