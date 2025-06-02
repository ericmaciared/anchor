import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/features/shared/confetti/confetti_provider.dart';
import 'package:anchor/features/tasks/domain/entities/subtask.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/providers/task_provider.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_actions_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskController {
  final WidgetRef ref;
  final BuildContext context;

  TaskController(this.ref, this.context);

  List<Task> getTasksForDay(DateTime day) {
    final tasks = ref.watch(taskProvider);
    return tasks.where((t) => isSameDay(t.day, day)).toList();
  }

  void showEditTaskModal(Task task) {
    final taskNotifier = ref.read(taskProvider.notifier);
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

  void showCreateTaskModal() {
    final taskNotifier = ref.read(taskProvider.notifier);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskActionsModal(
        onSubmit: (task) => taskNotifier.createTask(task),
      ),
    );
  }

  void toggleTaskCompletion(Task task) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final confettiController = ref.read(confettiProvider);

    final wasDone = task.isDone;
    taskNotifier.toggleTaskCompletion(task.id);
    if (!wasDone) confettiController.play();
  }

  void toggleSubtaskCompletion(Subtask subtask) {
    final taskNotifier = ref.read(taskProvider.notifier);
    taskNotifier.toggleSubtaskCompletion(
        taskId: subtask.taskId, subtaskId: subtask.id);
  }
}
