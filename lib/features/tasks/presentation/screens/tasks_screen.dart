import 'package:anchor/features/tasks/application/providers/task_provider.dart';
import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_actions_dialog.dart';
import 'package:anchor/features/tasks/presentation/widgets/task_list.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void triggerConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);

    final scheduledTasks = tasks.where((t) => t.startTime != null).toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));
    final unscheduledTasks = tasks.where((t) => t.startTime == null).toList();

    void handleLongPress(Task task) {
      showDialog(
        context: context,
        builder: (_) => TaskActionsDialog(
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('good morning.'),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => TaskActionsDialog(
                onSubmit: (task) => taskNotifier.addTask(task),
              ),
            ),
            tooltip: 'Add Task',
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        children: [
          tasks.isEmpty
              ? const Center(child: Text('No tasks yet.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TaskList(
                      tasks: unscheduledTasks,
                      label: 'Unscheduled Tasks',
                      onComplete: (task) {
                        final wasDone = task.isDone;
                        taskNotifier.toggleTask(task.id);
                        if (!wasDone) triggerConfetti();
                      },
                      onLongPress: handleLongPress,
                    ),
                    TaskList(
                      tasks: scheduledTasks,
                      label: 'Scheduled Tasks',
                      onComplete: (task) {
                        final wasDone = task.isDone;
                        taskNotifier.toggleTask(task.id);
                        if (!wasDone) triggerConfetti();
                      },
                      onLongPress: handleLongPress,
                    ),
                  ],
                ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              gravity: 0.3,
              emissionFrequency: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}
