import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskHeaderRow extends StatelessWidget {
  final Task task;

  const TaskHeaderRow({super.key, required this.task});

  String _buildSubtitle(Task task) {
    if (task.startTime != null) {
      if (task.duration == null) {
        return DateFormat('HH:mm').format(task.startTime!);
      }
      final endTime = task.startTime!.add(task.duration ?? Duration.zero);
      return '${DateFormat('HH:mm').format(task.startTime!)} - ${DateFormat('HH:mm').format(endTime)} (${task.duration?.inMinutes ?? 0} min)';
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
          color: task.isDone ? Colors.grey : null,
          size: 30,
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
                style: TextStyle(
                  color: task.isDone ? Colors.grey : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          task.isDone ? Icons.check_circle : Icons.circle_outlined,
          color: !task.isDone ? task.color : Colors.grey,
        ),
      ],
    );
  }
}
