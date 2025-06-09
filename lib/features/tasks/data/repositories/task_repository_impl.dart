import 'package:anchor/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:anchor/features/tasks/domain/entities/task_model.dart';
import 'package:anchor/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource taskLocalDataSource;

  TaskRepositoryImpl(this.taskLocalDataSource);

  @override
  Future<List<TaskModel>> getAllTasks() {
    return taskLocalDataSource.getAllTasks();
  }

  @override
  Future<void> createTask(TaskModel task) {
    return taskLocalDataSource.createTask(task);
  }

  @override
  Future<void> updateTask(TaskModel task) {
    return taskLocalDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) {
    return taskLocalDataSource.deleteTask(id);
  }
}
