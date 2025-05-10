import 'package:anchor/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:anchor/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskRepository repository;

  TaskNotifier(this.repository) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await repository.getTasks();
    state = tasks;
  }

  Future<void> toggleTask(String taskId) async {
    final updatedTasks = state.map((task) {
      return task.id == taskId ? task.copyWith(isDone: !task.isDone) : task;
    }).toList();

    final updatedTask = updatedTasks.firstWhere((task) => task.id == taskId);
    await repository.updateTask(updatedTask);
    state = updatedTasks;
  }

  Future<void> addTask(Task task) async {
    await repository.addTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task updatedTask) async {
    await repository.updateTask(updatedTask);
    state = state.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
  }

  Future<Task?> deleteTask(String taskId) async {
    try {
      final taskToDelete = state.firstWhere((task) => task.id == taskId);

      await repository.deleteTask(taskId);
      state = state.where((task) => task.id != taskId).toList();

      return taskToDelete;
    } catch (_) {
      return null;
    }
  }

  Future<void> undoDelete(Task task) async {
    await repository.addTask(task);
    state = [...state, task];
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>(
  (ref) => TaskNotifier(TaskRepositoryImpl(TaskLocalDataSource())),
);
