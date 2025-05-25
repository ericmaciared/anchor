import 'package:anchor/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();

  Future<void> createTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);
}
