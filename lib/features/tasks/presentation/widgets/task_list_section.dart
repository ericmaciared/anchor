import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/features/shared/greetings/presentation/widgets/greeting_card.dart';
import 'package:anchor/features/shared/quotes/presentation/widgets/daily_quote_card.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_list.dart';
import 'package:flutter/material.dart';

class TaskListSection extends StatelessWidget {
  final DateTime selectedDay;
  final List<TaskModel> selectedDayTasks;
  final void Function(TaskModel task) onToggleTaskCompletion;
  final void Function(SubtaskModel subtask) onToggleSubtaskCompletion;
  final void Function(TaskModel task) onLongPress;

  const TaskListSection({
    super.key,
    required this.selectedDay,
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
        if (selectedDay == normalizeDate(DateTime.now())) GreetingCard(),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Divider(),
        ),
        DailyQuoteCard(),
        const SizedBox(height: 112),
      ],
    );
  }
}
