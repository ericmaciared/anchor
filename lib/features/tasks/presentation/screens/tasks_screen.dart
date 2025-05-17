import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/features/shared/confetti/confetti_provider.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/providers/task_provider.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_actions_modal.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/empty_task_state.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card/task_list_section.dart';
import 'package:anchor/features/tasks/presentation/widgets/tasks_screen_app_bar.dart';
import 'package:anchor/features/tasks/presentation/widgets/week_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  DateTime _selectedDay = normalizeDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);
    final confettiController = ref.read(confettiProvider);

    final todayTasks =
        tasks.where((t) => isSameDay(t.day, _selectedDay)).toList();

    void handleLongPress(Task task) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => TaskActionsModal(
          initialTask: task,
          onSubmit: (updatedTask) => taskNotifier.updateTask(updatedTask),
          onDelete: (deletedTask) async {
            final deleted = await taskNotifier.deleteTask(deletedTask.id);
            if (deleted != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task "${deleted.title}" deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      taskNotifier.undoDelete(deleted);
                    },
                  ),
                ),
              );
            }
          },
        ),
      );
    }

    void handleCompletion(Task task) {
      final wasDone = task.isDone;
      taskNotifier.toggleTask(task.id);
      if (!wasDone) confettiController.play();
    }

    return Scaffold(
      appBar: TasksScreenAppBar(
        onAddTask: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TaskActionsModal(
            onSubmit: (task) => taskNotifier.addTask(task),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            WeekCalendar(
              selectedDay: _selectedDay,
              onDaySelected: (day) => setState(() {
                _selectedDay = normalizeDate(day);
              }),
            ),
            Expanded(
              child: todayTasks.isEmpty
                  ? EmptyTaskState(
                      onAdd: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => TaskActionsModal(
                          onSubmit: (task) => taskNotifier.addTask(task),
                        ),
                      ),
                    )
                  : TaskListSection(
                      selectedDayTasks: todayTasks,
                      onComplete: handleCompletion,
                      onLongPress: handleLongPress,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
