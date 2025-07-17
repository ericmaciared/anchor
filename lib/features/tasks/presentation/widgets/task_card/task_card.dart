import 'package:anchor/core/theme/text_sizes.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:flutter/material.dart';

import 'task_expanded_actions.dart';
import 'task_header_row.dart';
import 'task_progress_bar.dart';
import 'task_time_column.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onLongPress;
  final VoidCallback onToggleTaskCompletion;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;

  const TaskCard({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.onToggleTaskCompletion,
    required this.onToggleSubtaskCompletion,
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

  Future<void> _showUndoConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Undo Completion',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: TextSizes.XL)),
          content: Text('Are you sure you want to undo this task completion?',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: TextSizes.M)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: TextSizes.M,
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onToggleTaskCompletion();
              },
              child: Text(
                'Undo',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: TextSizes.M,
                    color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TaskTimeColumn(
                  startTime: task.startTime, duration: task.duration),
              const SizedBox(width: 8),
              Builder(builder: (context) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 50,
                    // Let height be dynamic based on card height
                    maxHeight: constraints.maxHeight,
                  ),
                  child: TaskProgressBar(
                    color: task.color,
                  ),
                );
              }),
              const SizedBox(width: 12),
              // Main task card
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                          TaskHeaderRow(task: task),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: _isExpanded
                                ? TaskExpandedActions(
                                    task: task,
                                    onComplete: () {
                                      setState(() => _isExpanded = false);
                                      widget.onToggleTaskCompletion();
                                    },
                                    showUndoDialog: () =>
                                        _showUndoConfirmationDialog(context),
                                    onUndoComplete:
                                        widget.onToggleTaskCompletion,
                                    onToggleSubtaskCompletion: (subtask) =>
                                        widget
                                            .onToggleSubtaskCompletion(subtask),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
