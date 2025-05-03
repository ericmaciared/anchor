// tasks_provider.dart
import 'package:anchor/features/tasks/data/tasks_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anchor/features/tasks/models/task_model.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return TasksNotifier(repo);
});

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;

  TasksNotifier(this._repository) : super(const AsyncLoading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _repository.getAllTasks();
      state = AsyncData(tasks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _repository.insertTask(task);
      _loadTasks(); // Refresh state
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
