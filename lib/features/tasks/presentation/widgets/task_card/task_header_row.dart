import 'package:anchor/core/theme/color_opacities.dart';
import 'package:anchor/core/theme/spacing_sizes.dart';
import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/core/utils/context_extensions.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

class TaskHeaderRow extends StatelessWidget {
  final TaskModel task;

  const TaskHeaderRow({super.key, required this.task});

  String _buildSubtitle(TaskModel task) {
    if (task.duration != null) {
      if (task.subtasks.isNotEmpty) {
        final completedSubtasks = task.subtasks.where((sub) => sub.isDone);
        return '(${task.duration?.inMinutes ?? 0} min) - ${completedSubtasks.length}/${task.subtasks.length}';
      }
      return '(${task.duration?.inMinutes ?? 0} min)';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _buildSubtitle(task);

    return Row(
      children: [
        Icon(
          task.icon,
          color: context.colors.onSurface.withAlpha(ColorOpacities.opacity60),
          size: 24,
        ),
        const SizedBox(width: SpacingSizes.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.titleMedium!.copyWith(
                  color: task.isDone ? context.colors.onSurface.withAlpha(ColorOpacities.opacity60) : null,
                  fontSize: TextSizes.m,
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle,
                    style: context.textStyles.titleMedium!.copyWith(
                        fontSize: TextSizes.s, color: context.colors.onSurface.withAlpha(ColorOpacities.opacity60))),
            ],
          ),
        ),
        const SizedBox(width: SpacingSizes.s),
        Icon(
          task.isDone ? Icons.check_circle : Icons.circle_outlined,
          color: !task.isDone ? task.color : context.colors.onSurface.withAlpha(ColorOpacities.opacity60),
        ),
      ],
    );
  }
}
