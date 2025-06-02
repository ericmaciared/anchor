import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart';
import 'package:anchor/features/tasks/domain/entities/subtask.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_list.dart';
import 'package:flutter/material.dart';

class TaskListSection extends StatelessWidget {
  final List<Task> selectedDayTasks;
  final void Function(Task task) onToggleTaskCompletion;
  final void Function(Subtask subtask) onToggleSubtaskCompletion;
  final void Function(Task task) onLongPress;

  const TaskListSection({
    super.key,
    required this.selectedDayTasks,
    required this.onToggleTaskCompletion,
    required this.onToggleSubtaskCompletion,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheduledTasks = selectedDayTasks
        .where((t) => t.startTime != null)
        .toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

    final unscheduledTasks =
        selectedDayTasks.where((t) => t.startTime == null).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        DailyQuoteCard(),
        TaskList(
          tasks: unscheduledTasks,
          label: 'Unscheduled Tasks',
          onToggleTaskCompletion: onToggleTaskCompletion,
          onToggleSubtaskCompletion: onToggleSubtaskCompletion,
          onLongPress: onLongPress,
        ),
        TaskList(
          tasks: scheduledTasks,
          label: 'Scheduled Tasks',
          onToggleTaskCompletion: onToggleTaskCompletion,
          onToggleSubtaskCompletion: onToggleSubtaskCompletion,
          onLongPress: onLongPress,
        ),
      ],
    );
  }
}
