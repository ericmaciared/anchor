import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onLongPress,
  });

  String _buildSubtitle() {
    if (task.startTime == null && task.duration == null) return '';
    final buffer = StringBuffer();

    if (task.startTime != null) {
      final formattedTime = DateFormat('HH:mm').format(task.startTime!);
      buffer.write('Starts at $formattedTime');
    }

    if (task.duration != null) {
      if (buffer.isNotEmpty) buffer.write(' • ');
      final minutes = task.duration!.inMinutes;
      buffer.write('Duration: ${minutes}min');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: _buildSubtitle().isNotEmpty ? Text(_buildSubtitle()) : null,
        leading: Icon(
          task.isDone ? Icons.check_circle : Icons.circle_outlined,
          color: task.isDone ? Colors.green : Colors.grey,
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
