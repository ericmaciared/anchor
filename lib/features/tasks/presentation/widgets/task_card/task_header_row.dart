import 'package:anchor/core/theme/text_sizes.dart';
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
          color: task.isDone
              ? Theme.of(context).colorScheme.onSurface.withAlpha(150)
              : Theme.of(context).colorScheme.onSurface.withAlpha(150),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: task.isDone
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(150)
                          : null,
                      fontSize: TextSizes.M,
                      decoration:
                          task.isDone ? TextDecoration.lineThrough : null,
                    ),
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: TextSizes.S,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(150))),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          task.isDone ? Icons.check_circle : Icons.circle_outlined,
          color: !task.isDone
              ? task.color
              : Theme.of(context).colorScheme.onSurface.withAlpha(150),
        ),
      ],
    );
  }
}
