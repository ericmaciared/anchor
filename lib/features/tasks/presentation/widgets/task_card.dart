import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onLongPress;
  final VoidCallback onComplete;
  final VoidCallback? onUndoComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onLongPress,
    this.onUndoComplete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  String _buildSubtitle(Task task) {
    final buffer = StringBuffer();

    if (task.startTime != null) {
      buffer.write('Starts at ${DateFormat('HH:mm').format(task.startTime!)}');
    }

    if (task.duration != null) {
      if (buffer.isNotEmpty) buffer.write(' • ');
      buffer.write('Duration: ${task.duration!.inMinutes}min');
    }

    return buffer.toString();
  }

  Widget _buildTimeColumn(Task task) {
    if (task.startTime == null) return const SizedBox.shrink();

    final endTime = task.startTime!.add(task.duration ?? Duration.zero);

    return SizedBox(
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('HH:mm').format(task.startTime!),
              textAlign: TextAlign.center),
          if (task.duration != null)
            Text(DateFormat('HH:mm').format(endTime),
                textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future<void> _showUndoConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Undo Completion'),
          content:
              const Text('Are you sure you want to undo this task completion?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onUndoComplete?.call();
              },
              child: const Text('Undo'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpandedAction(Task task) {
    if (!_isExpanded) return const SizedBox.shrink();

    if (task.isDone && widget.onUndoComplete != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  onPressed: () => _showUndoConfirmationDialog(context),
                  child: const Text('Undo'),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (task.isDone && widget.onUndoComplete == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          'Task completed!',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              setState(() => _isExpanded = false);
              widget.onComplete();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: task.color,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Text(
                'Hold to Complete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final subtitle = _buildSubtitle(task);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          _buildTimeColumn(task),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 16,
            height: _isExpanded ? 130 : 50,
            decoration: BoxDecoration(
              color: task.color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: GestureDetector(
                onTap: _toggleExpanded,
                onLongPress: widget.onLongPress,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            task.isDone
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: task.isDone ? task.color : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: _buildExpandedAction(task),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
