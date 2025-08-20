// lib/features/tasks/presentation/controllers/task_controller.dart
import 'package:anchor/core/utils/date_utils.dart';
import 'package:anchor/core/widgets/adaptive_snackbar_widget.dart'; // Add this import
import 'package:anchor/features/shared/confetti/confetti_provider.dart';
import 'package:anchor/features/shared/settings/settings_provider.dart';
import 'package:anchor/features/tasks/domain/entities/subtask_model.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/presentation/providers/task_provider.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions/task_actions_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskController {
  final WidgetRef ref;
  final BuildContext context;

  TaskController(this.ref, this.context);

  List<TaskModel> getTasksForDay(DateTime day) {
    final tasks = ref.watch(taskProvider);
    return tasks.where((t) => isSameDay(t.day, day)).toList();
  }

  void showEditTaskModal(TaskModel task) {
    final taskNotifier = ref.read(taskProvider.notifier);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskActionsModal(
        taskDay: task.day,
        initialTask: task,
        onSubmit: (updatedTask) {
          taskNotifier.updateTask(updatedTask);
          context.showSuccessSnackbar(
            'Task "${updatedTask.title}" updated successfully',
          );
        },
        onDelete: (deletedTask) async {
          final deleted = await taskNotifier.deleteTask(deletedTask.id);
          if (deleted != null && context.mounted) {
            context.showUndoSnackbar(
              'Task "${deleted.title}" deleted',
              () => taskNotifier.undoDelete(deleted),
            );
          }
        },
      ),
    );
  }

  void showCreateTaskModal({required DateTime taskDay}) {
    final taskNotifier = ref.read(taskProvider.notifier);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskActionsModal(
        taskDay: taskDay,
        onSubmit: (task) {
          taskNotifier.createTask(task);
        },
      ),
    );
  }

  void toggleTaskCompletion(TaskModel task) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final wasDone = task.isDone;
    taskNotifier.toggleTaskCompletion(task.id);

    if (!wasDone) {
      // Task was completed
      ref.read(settingsProvider).whenData((settings) {
        if (settings.visualEffectsEnabled) {
          final confettiController = ref.read(confettiProvider);
          confettiController.play();
        }
      });
    }
  }

  void toggleSubtaskCompletion(SubtaskModel subtask) {
    final taskNotifier = ref.read(taskProvider.notifier);
    taskNotifier.toggleSubtaskCompletion(taskId: subtask.taskId, subtaskId: subtask.id);
  }
}
