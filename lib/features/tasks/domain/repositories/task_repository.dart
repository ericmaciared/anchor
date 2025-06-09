import 'package:anchor/features/tasks/domain/entities/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTasks();

  Future<void> createTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);
}
