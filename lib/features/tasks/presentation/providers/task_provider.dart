import 'package:anchor/features/shared/notifications/notification_service.dart';
import 'package:anchor/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:anchor/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
  (ref) => TaskNotifier(
    repository: TaskRepositoryImpl(TaskLocalDataSource(ref)),
    notificationService: ref.read(notificationServiceProvider),
  ),
);

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskRepository repository;
  final NotificationService notificationService;

  TaskNotifier({
    required this.repository,
    required this.notificationService,
  }) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await repository.getAllTasks();
    state = tasks;
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final updatedTasks = state.map((task) {
      return task.id == taskId ? task.copyWith(isDone: !task.isDone) : task;
    }).toList();

    final updatedTask = updatedTasks.firstWhere((task) => task.id == taskId);
    await repository.updateTask(updatedTask);
    state = updatedTasks;
  }

  Future<void> toggleSubtaskCompletion({
    required String taskId,
    required String subtaskId,
  }) async {
    final task = state.firstWhere((t) => t.id == taskId);

    final updatedSubtasks = task.subtasks.map((sub) {
      return sub.id == subtaskId ? sub.copyWith(isDone: !sub.isDone) : sub;
    }).toList();

    final updatedTask = task.copyWith(subtasks: updatedSubtasks);

    await repository.updateTask(updatedTask);
    state = state.map((t) => t.id == taskId ? updatedTask : t).toList();
  }

  Future<void> createTask(TaskModel task) async {
    await repository.createTask(task);

    // Schedule notifications
    for (final notification in task.notifications) {
      await notificationService.scheduleNotification(
          notification, 'Time to progress', task.title);
    }

    state = [...state, task];
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    // Find old task to cancel existing notifications
    final oldTask = state.firstWhere((task) => task.id == updatedTask.id);

    // Cancel old notifications
    for (final notification in oldTask.notifications) {
      await notificationService.cancelNotification(notification.notificationId);
    }

    await repository.updateTask(updatedTask);

    // Schedule new notifications
    for (final notification in updatedTask.notifications) {
      await notificationService.scheduleNotification(
          notification,
          'Time to progress',
          '${updatedTask.title} (${updatedTask.duration} mins)');
    }

    state = state.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
  }

  Future<TaskModel?> deleteTask(String taskId) async {
    try {
      final taskToDelete = state.firstWhere((task) => task.id == taskId);

      // Cancel notifications
      for (final notification in taskToDelete.notifications) {
        await notificationService
            .cancelNotification(notification.notificationId);
      }

      await repository.deleteTask(taskId);
      state = state.where((task) => task.id != taskId).toList();

      return taskToDelete;
    } catch (_) {
      return null;
    }
  }

  Future<void> undoDelete(TaskModel task) async {
    await repository.createTask(task);

    // Reschedule notifications
    for (final notification in task.notifications) {
      await notificationService.scheduleNotification(
          notification, 'Time to progress', task.title);
    }

    state = [...state, task];
  }
}
