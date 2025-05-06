import 'package:anchor/features/tasks/application/providers/task_provider.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions_dialog.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);

    final sortedTasks = [...tasks]..sort((a, b) {
        final aTime = a.startTime;
        final bTime = b.startTime;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1; // nulls last
        if (bTime == null) return -1;
        return aTime.compareTo(bTime);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('good morning.'),
      ),
      body: sortedTasks.isEmpty
          ? const Center(child: Text('No tasks yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedTasks.length,
              itemBuilder: (context, index) {
                final task = sortedTasks[index];
                return TaskCard(
                  task: task,
                  onTap: () => taskNotifier.toggleTask(task.id),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => TaskActionsDialog(
                        initialTask: task,
                        onSubmit: (updatedTask) =>
                            taskNotifier.addTask(updatedTask),
                        onDelete: (deletedTask) async {
                          final deleted =
                              await taskNotifier.deleteTask(deletedTask.id);
                          if (deleted != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Task "${deleted.title}" deleted'),
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
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => TaskActionsDialog(
            onSubmit: (task) => taskNotifier.addTask(task),
          ),
        ),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
