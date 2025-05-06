import 'package:anchor/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() {
    return localDataSource.getTasks();
  }

  @override
  Future<void> addTask(Task task) {
    return localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) {
    return localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) {
    return localDataSource.deleteTask(id);
  }
}
